//
//  Group.swift
//  Maia
//
//  Created by José Ruiz on 8/10/24.
//

import Foundation

struct Group: Codable, Equatable, Hashable, Identifiable {
    var id: String { name }
    var name: String
    var domains: [Domain]
}
