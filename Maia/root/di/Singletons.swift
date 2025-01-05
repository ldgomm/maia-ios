//
//  Singletons.swift
//  Maia
//
//  Created by José Ruiz on 29/7/24.
//

import Foundation
import SwiftData

class Singletons {
    
    init (_ modelContext: ModelContext) {
        @Singleton var serviceable: Serviceable = Service() as Serviceable
        @Singleton var messageRepositoriable: MessageRepositoriable = MessageRepository(modelContext: modelContext) as MessageRepositoriable
    }
}
