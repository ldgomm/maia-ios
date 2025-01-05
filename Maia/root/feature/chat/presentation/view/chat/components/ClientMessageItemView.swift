//
//  ClientMessageItemView.swift
//  Maia
//
//  Created by José Ruiz on 10/7/24.
//

import SwiftUI

struct ClientMessageItemView: View {
    var message: Message
    var product: Product?
    
    @State private var expanded: Bool = true
    @State private var isShowingProduct: Bool = false
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
            HStack {
                Text(message.text)
                    .font(.body)
                    .padding(8)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(12)
                    .frame(maxWidth: .infinity * 0.8, alignment: .leading)
                    .onTapGesture {
                        if product != nil {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                expanded.toggle()
                            }
                        }
                    }
                Spacer()
            }
            if expanded, let product = product {
                NavigationLink(destination: ProductView(product: product)) {
                    ProductItemView(product: product)
                        .frame(maxWidth: .infinity * 0.8, alignment: .leading)
                        .padding(.trailing, 70)
                        .padding(.vertical, 4)
                }
                Spacer()
            }
        }
        .padding(.leading, 12)
    }
    
    init(message: Message, product: Product? = nil) {
        self.message = message
        self.product = product
    }
}
