//
//  ChatViewModel.swift
//  Maia
//
//  Created by José Ruiz on 9/7/24.
//

import Combine
import FirebaseAuth
import Foundation
import SwiftData

@MainActor
class ChatViewModel: ObservableObject {
    @Published private(set) var messages: [Message] = []
    
    private var cancellables: Set<AnyCancellable> = []
    private let repository: MessageRepository
    private let markMessageAsReadUseCase: MarkMessageAsReadUseCase = .init()

    let user: String

    init(modelContext: ModelContext) {
        self.user = Auth.auth().currentUser?.uid ?? ""
        self.repository = MessageRepository(modelContext: modelContext)
        getMessages()
    }
    
    func getMessages() {
        repository.$messages
            .assign(to: \.messages, on: self)
            .store(in: &cancellables)
    }

    func sendMessageToClient(message: Message) {
        repository.addMessage(message.toMessageDto())
    }
    
    func markMessageAsRead(_ message: MessageEntity) {
        markMessageAsReadUseCase.invoke(message: message)
    }
}
