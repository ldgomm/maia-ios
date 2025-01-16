//
//  GetCategoriesUseCase.swift
//  Maia
//
//  Created by José Ruiz on 8/10/24.
//

import Combine
import Foundation

class GetGroupsUseCase {
    @Inject var serviceable: Serviceable

    /**
     This function invokes the get data operation from the provided URL using the injected service.
     - Parameter url: The URL from which to retrieve data.
     - Returns: A publisher emitting a Result type with the retrieved data or a NetworkError.
     */
    func invoke(from url: URL) -> AnyPublisher<Result<[Group], NetworkError>, Never> {
        return serviceable.getData(from: url)
    }
}
