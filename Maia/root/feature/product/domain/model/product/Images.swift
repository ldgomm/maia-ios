//
//  Images.swift
//  Sales
//
//  Created by José Ruiz on 4/4/24.
//

import Foundation

struct Images {
    var product: [ImageX]
    var box: [ImageX]? = nil
    
    init(product: [ImageX], box: [ImageX]? = nil) {
        self.product = product
        self.box = box
    }
}
