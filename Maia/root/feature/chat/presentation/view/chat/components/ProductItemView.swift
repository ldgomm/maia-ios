//
//  ProductItemView.swift
//  Maia
//
//  Created by José Ruiz on 10/7/24.
//

import SwiftUI

struct ProductItemView: View {
    var product: Product
    
    var body: some View {
        NavigationLink(value: product) {
            ZStack {
                if product.price.offer.isActive {
                    ChrismasCardView()
                }
                HStack {
                    ImageWithRetry(url: URL(string: product.image.url)!)
                        .frame(width: 70, height: 70)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    VStack(alignment: .leading) {
                        Text(product.name)
                            .bold()
                            .font(.headline)
                            .foregroundColor(.primary)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                        
                        Text(product.label ?? "")
                            .bold()
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        if product.price.offer.isActive {
                            Text("\(Int(product.price.offer.discount))% OFF")
                                .font(.caption)
                                .padding(5)
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(5)
                                .padding(.trailing, 5)
                            let discount = Double(product.price.offer.discount) / 100.0
                            let discountedPrice = product.price.amount * (1.0 - Double(discount))
                            
                            Text("\(discountedPrice, format: .currency(code: product.price.currency))")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                            Text("\(product.price.amount, format: .currency(code: product.price.currency))")
                                .font(.caption)
                                .strikethrough()
                                .foregroundColor(.secondary)
                            
                        } else {
                            Text(product.price.amount, format: .currency(code: product.price.currency))
                                .font(.subheadline)
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.1)))
        }
    }
}
