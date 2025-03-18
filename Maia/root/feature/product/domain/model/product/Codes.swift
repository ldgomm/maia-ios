//
//  Codes.swift
//  Maia
//
//  Created by José Ruiz on 17/3/25.
//

import Foundation

struct Codes {
    var EAN: String
    
    func toCodesDto() -> CodesDto {
        return CodesDto(EAN: EAN)
    }
}
