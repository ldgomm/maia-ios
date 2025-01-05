//
//  SendMessageUseCase.swift
//  Maia
//
//  Created by José Ruiz on 9/7/24.
//

import Foundation
import Combine

class SendMessageUseCase {
    @Inject var repositorable: MessageRepositoriable

    func invoke(message: MessageDto) {
        return repositorable.addMessage(message)
    }
}
