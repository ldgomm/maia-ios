//
//  StoreInformation.swift
//  Maia
//
//  Created by José Ruiz on 9/7/24.
//

import Foundation

//struct StoreInformation: Hashable, Identifiable {
//    
//    static func == (lhs: StoreInformation, rhs: StoreInformation) -> Bool {
//        return lhs.id == rhs.id
//    }
//    
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
//
//    var id: String
//    var name: String
//    var image: ImageX
//    var address: Address
//    var phoneNumber: String
//    var emailAddress: String
//    var website: String
//    var description: String
//    var returnPolicy: String
//    var refundPolicy: String
//    var brands: [String]
//    var status: Status
//    
//    func toStoreInformationDto() -> StoreInformationDto {
//        return StoreInformationDto(id: id,
//                                   name: name,
//                                   image: image.toImageDto(),
//                                   address: address.toAddressDto(),
//                                   phoneNumber: phoneNumber,
//                                   emailAddress: emailAddress,
//                                   website: website,
//                                   description: description,
//                                   returnPolicy: returnPolicy,
//                                   refundPolicy: refundPolicy,
//                                   brands: brands,
//                                   status: status.toStatusDto())
//    }
//}
