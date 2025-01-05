//
//  MessageRepository.swift
//  Maia
//
//  Created by José Ruiz on 10/7/24.
//

import Combine
import FirebaseAuth
import FirebaseFirestore
import Foundation
import SwiftData

final class MessageRepository: MessageRepositoriable {
    @Published private(set) var messages: [Message] = []
    
    private var modelContext: ModelContext
    private let db = Firestore.firestore().collection("messages")
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchMessages()
    }
    
    func addMessage(_ message: MessageDto) {
        do {
            let messageEntity = message.toMessageEntity()
            modelContext.insert(messageEntity)
            
            try db.addDocument(from: message) { error in
                if let error = error {
                    print("Error adding message to Firestore: \(error.localizedDescription)")
                } else {
                    print("Message successfully added to Firestore")
                }
            }
        } catch {
            print("Error adding message: \(error.localizedDescription)")
        }
    }
    
    func fetchMessages() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User is not authenticated")
            return
        }
        
        db.whereField("storeId", isEqualTo: userId)
            .whereField("status", isEqualTo: MessageStatusEntity.sent.rawValue)
            .whereField("fromClient", isEqualTo: true)
            .order(by: "date")
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error fetching documents: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("No documents found")
                    return
                }
                
                do {
                    let descriptor = FetchDescriptor<MessageEntity>(sortBy: [SortDescriptor(\.date)])
                    let localMessages = try self.modelContext.fetch(descriptor).map { $0.toMessage() }
                    for document in documents {
                        let messageDto = try document.data(as: MessageDto.self)
                        let messageEntity = messageDto.toMessageEntity()
                        self.messages.append(messageEntity.toMessage())
                        if !localMessages.contains(where: { $0.id == messageEntity.id }) {
                            self.modelContext.insert(messageEntity)
                        } else {
                            print("Message with id \(messageEntity.id) already exists")
                        }
                    }
                } catch {
                    print("Error inserting message: \(error.localizedDescription)")
                }
            }
    }
    
    func markMessageAsRead(_ message: MessageEntity) {
        let query = db.whereField("clientId", isEqualTo: message.clientId)
                      .whereField("storeId", isEqualTo: message.storeId)
                      .whereField("date", isEqualTo: message.date)
                      .limit(to: 1)

        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else if let documents = querySnapshot?.documents, !documents.isEmpty {
                // Assuming the first document is the one we want to update
                let document = documents[0]
                document.reference.updateData(["status": MessageStatusEntity.read.rawValue]) { error in
                    if let error = error {
                        print("Error updating status in Firestore: \(error)")
                    } else {
                        // Optionally update your local data model here
                        message.status = .read
                        // For example, update the message in your local database or data source
                        // updateLocalMessage(message)
                        print("Message status successfully updated in Firestore")
                    }
                }
            } else {
                print("No matching document found")
            }
        }
    }

}
