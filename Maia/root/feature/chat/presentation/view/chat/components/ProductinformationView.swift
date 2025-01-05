//
//  ProductinformationView.swift
//  Maia
//
//  Created by José Ruiz on 10/7/24.
//

import FirebaseAuth
import SwiftUI

//struct ProductInformationView: View {
//    @EnvironmentObject var viewModel: ChatViewModel
//    @Environment(\.dismiss) var dismiss
//    
//    var product: Product?
//        
//    var body: some View {
//        if let product {
//            VStack {
//                ScrollView {
//                    VStack(alignment: .leading, spacing: 16) {
//                        CachedAsyncImage(url: URL(string: product.image.url)!) { phase in
//                            switch phase {
//                            case .empty:
//                                ProgressView()
//                                    .frame(width: 50, height: 50)
//                            case .success(let image):
//                                image
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fit)
//                                    .clipShape(RoundedRectangle(cornerRadius: 8))
//                            case .failure:
//                                Image(systemName: "photo")
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fit)
//                                    .clipShape(RoundedRectangle(cornerRadius: 11))
//                                    .frame(width: 50, height: 50)
//                                    .padding(.horizontal)
//                                    .foregroundColor(.gray)
//                            @unknown default:
//                                EmptyView()
//                            }
//                        }
//                        .frame(maxWidth: .infinity, maxHeight: 300)
//                        
//                        Text(product.description)
//                            .foregroundColor(.gray)
//                        
//                            VStack {
//                                Text("Origin: \(product.origin)")
//                                Text("Stock: \(product.stock)")
//                            }
//                        
//                        
//                            Text(formatPrice(amount: product.price.amount, currency: product.price.currency))
//                                .font(.headline)
//                                .foregroundColor(.blue)
//                            if product.price.offer.isActive {
//                                Text("Discount: \(product.price.offer.discount)%")
//                                    .foregroundColor(.red)
//                            }
//                        
//                        if let warranty = product.warranty {
//                            Group {
//                                Text("Warranty")
//                                    .font(.headline)
//                                Text("Warranty Available: \(warranty.hasWarranty ? "Yes" : "No")")
//                                if warranty.hasWarranty {
//                                    Text("Months: \(warranty.months)")
//                                    Text("Details: \(warranty.details.joined(separator: ", "))")
//                                }
//                            }
//                            .padding(.top, 8)
//                        }
//                    }
//                    .padding(16)
//                }
//                .navigationBarTitle(Text(product.name), displayMode: .inline)
//            }
//        }
//    }
//}
