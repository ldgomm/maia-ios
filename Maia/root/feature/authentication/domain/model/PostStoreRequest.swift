//
//  PostStoreRequest.swift
//  Maia
//
//  Created by José Ruiz on 20/6/24.
//

import Foundation

struct PostStoreRequest: Codable {
    var key: String? = getMaiaKey()
    var store: StoreDto
}
