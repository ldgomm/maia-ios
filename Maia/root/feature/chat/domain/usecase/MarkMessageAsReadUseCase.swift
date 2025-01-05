//
//  SendMessageUseCase.swift
//  Maia
//
//  Created by José Ruiz on 9/7/24.
//

import Foundation
import Combine

class MarkMessageAsReadUseCase {
    @Inject var repositorable: MessageRepositoriable

    func invoke(message: MessageEntity) {
        return repositorable.markMessageAsRead(message)
    }
}
