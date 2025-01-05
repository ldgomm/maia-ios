//
//  ChatMessage.swift
//  Maia
//
//  Created by José Ruiz on 9/7/24.
//

import Foundation

struct ChatMessage: Identifiable {
    let id: String
    let message: String
    let isUser: Bool
    let products: [Product]?

    init(id: String = UUID().uuidString, message: String, isUser: Bool, products: [Product]? = nil) {
        self.id = id
        self.message = message
        self.isUser = isUser
        self.products = products
    }
}
