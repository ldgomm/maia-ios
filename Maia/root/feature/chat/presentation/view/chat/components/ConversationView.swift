//
//  ConversationView.swift
//  Maia
//
//  Created by José Ruiz on 10/7/24.
//

import SwiftUI

struct ConversationView: View {
    @EnvironmentObject var viewModel: ChatViewModel
    @State private var clientId: String
    @State private var storeId: String
    
    @State private var inputText: String = ""
    @State private var showButton = false
    
    let messages: [MessageEntity]
    let groupedMessages: [(key: Date, value: [MessageEntity])]
    
    var body: some View {
        VStack {
            ScrollViewReader { scrollView in
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(groupedMessages, id: \.key) { (day, messages) in
                            // Display day name in the center
                            Text(day.currentTimeMillis().formatShortHeadDate)
                                .font(.caption)
                                .padding(4)
                                .padding(.horizontal, 4)
                                .background(Color.teal.opacity(0.2))
                                .cornerRadius(4)
                                .frame(maxWidth: .infinity)
                            ForEach(messages) { message in
                                if message .fromClient {
                                    if let product: ProductDto = decodeFromJSON(message.product) {
                                        ClientMessageItemView(message: message.toMessage(), product: product.toProduct())
                                            .onAppear {
                                                if message.status != .read {
                                                    viewModel.markMessageAsRead(message)
                                                }
                                            }
                                            .id(message.id)
                                    } else {
                                        ClientMessageItemView(message: message.toMessage())
                                            .onAppear {
                                                if message.status != .read {
                                                    viewModel.markMessageAsRead(message)
                                                }
                                            }
                                            .id(message.id)
                                    }
                                } else {
                                    StoreMessageItemView(message: message.toMessage())
                                        .id(message.id)
                                }
                            }
                            
                        }
                        .onAppear {
                            if let lastMessage = messages.last {
                                withAnimation {
                                    scrollView.scrollTo(lastMessage.id, anchor: .bottom)
                                }
                            }
                        }
                    }
                }
                .onChange(of: messages.count) { _, _ in
                    if let lastMessage = messages.last {
                        withAnimation {
                            scrollView.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }
            HStack {
                TextField("Type a message...", text: $inputText)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5), lineWidth: 1))
                    .padding(.leading, 16)
                    .padding(.trailing, !inputText.isEmpty ? 8 : 16)
                    .onChange(of: inputText) { _, newValue in
                        if newValue.isEmpty {
                            withAnimation {
                                showButton = false
                            }
                        } else {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                if !inputText.isEmpty {
                                    withAnimation {
                                        showButton = true
                                    }
                                }
                            }
                        }
                    }
                if showButton {
                    Button {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            sendMessage()
                            inputText = ""
                        }
                    } label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.blue)
                            .padding(.trailing, 16)
                            .transition(.scale.combined(with: .opacity))
                    }
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(.vertical, 16)
            .background(Color(.systemBackground))
        }
        .navigationTitle(clientId.firstSixChars().lowercased())
        .navigationBarTitleDisplayMode(.inline)
    }
    
    init(messages: [MessageEntity]) {
        self.messages = messages
        self.groupedMessages = groupMessagesByDay(messages: messages)
            .sorted(by: { $0.key < $1.key })
            .map { ($0.key, $0.value.sorted(by: { $0.date < $1.date })) }
        self.clientId = messages.first?.clientId ?? ""
        self.storeId = messages.first?.storeId ?? ""
    }
    
    private func sendMessage() {
        guard !inputText.isEmpty else { return }
        let message = Message(text: inputText, fromClient: false, clientId: clientId, storeId: storeId)
        viewModel.sendMessageToClient(message: message)
        inputText = ""
    }
}

extension MessageEntity {
    var day: Date {
        let timeInterval = TimeInterval(date) / 1000 // Convert milliseconds to seconds
        let date = Date(timeIntervalSince1970: timeInterval)
        return Calendar.current.startOfDay(for: date) // Get the start of the day
    }
}

fileprivate func groupMessagesByDay(messages: [MessageEntity]) -> [Date: [MessageEntity]] {
    return messages.groupBy { $0.day }
}
