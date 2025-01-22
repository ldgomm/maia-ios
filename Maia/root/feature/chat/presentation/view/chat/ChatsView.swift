//
//  ChatsView.swift
//  Maia
//
//  Created by José Ruiz on 6/7/24.
//

import SwiftData
import SwiftUI

struct ChatsView: View {
    @EnvironmentObject private var viewModel: ChatViewModel
    @Query(sort: \MessageEntity.date) var messages: [MessageEntity]

    var body: some View {
        // Group messages by clientId
        // Sort the grouped messages by the date of the last message
        let sortedGroupedMessages = messages.groupBy { $0.clientId }.sorted {
            guard let lastMessage1 = $0.value.last, let lastMessage2 = $1.value.last else { return false }
            return lastMessage1.date > lastMessage2.date
        }

        NavigationStack {
            VStack {
                List {
                    ForEach(sortedGroupedMessages, id: \.key) { clientId, messages in
                        if let lastMessage = messages.last {
                            let sentOrDeliveredCount = messages.filter { ($0.status == .sent || $0.status == .delivered) && $0.fromClient }.count
                            NavigationLink {
                                ConversationView(messages: messages)
                                    .environmentObject(viewModel)
                            } label: {
                                ConversationItemView(message: lastMessage.toMessage(), sentOrDeliveredCount: sentOrDeliveredCount)
                            }
                            .frame(height: 60)
                        }
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Chats")
        }
    }
}
