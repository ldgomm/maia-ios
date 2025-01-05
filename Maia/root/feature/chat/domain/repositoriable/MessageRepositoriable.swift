//
//  MessageRepositoriable.swift
//  Maia
//
//  Created by José Ruiz on 9/7/24.
//

import Foundation

protocol MessageRepositoriable {
    
    func fetchMessages()
    
    func addMessage(_ message: MessageDto)
    
    func markMessageAsRead(_ message: MessageEntity)

}
