//
//  UIImage.swift
//  Maia
//
//  Created by José Ruiz on 29/7/24.
//

import SwiftUI

extension UIImage {
    
    func compressImage() -> Data? {
        return self.jpegData(compressionQuality: 0.1)
    }
}
