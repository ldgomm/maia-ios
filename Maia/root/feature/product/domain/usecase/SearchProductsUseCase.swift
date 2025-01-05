//
//  SearchProductsUseCase.swift
//  Maia
//
//  Created by José Ruiz on 19/6/24.
//

import Combine
import Foundation

class SearchProductByKeywordsUseCase {
    @Inject var serviceable: Serviceable

    /**
     This function invokes the get data operation from the provided URL using the injected service.
     - Parameter url: The URL from which to retrieve data.
     - Returns: A publisher emitting a Result type with the retrieved data or a NetworkError.
     */
    func invoke(from url: URL) -> AnyPublisher<Result<[ProductDto], NetworkError>, Never> {
        return serviceable.getDataByKeywords(from: url)
    }
}
