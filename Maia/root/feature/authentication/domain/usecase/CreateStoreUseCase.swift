//
//  CreateStoreUseCase.swift
//  Maia
//
//  Created by José Ruiz on 20/6/24.
//

import Combine
import Foundation

class CreateStoreUseCase {
    @Inject var serviceable: Serviceable

    func invoke(from url: URL, for request: PostStoreRequest) -> AnyPublisher<Result<LoginResponse, NetworkError>, Never> {
        return serviceable.postData(from: url, with: request)
    }
}
