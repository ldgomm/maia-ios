//
//  SearchCardView.swift
//  Maia
//
//  Created by José Ruiz on 4/8/24.
//

import SwiftUI

struct SearchCardView: View {
    let categories = ["iPhone", "iPad", "MacBook", "Samsung"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(LocalizedStringKey("explore_products_title"))
                .font(.title2)
                .bold()
                .foregroundColor(.primary)
                .padding(.bottom, 5)
                .fixedSize(horizontal: false, vertical: true)
            
            Text(LocalizedStringKey("explore_products_description"))
                .font(.body)
                .foregroundColor(.secondary)
                .padding(.bottom, 10)
                .fixedSize(horizontal: false, vertical: true)
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(categories, id: \.self) { category in
                    HStack(alignment: .top, spacing: 5) {
                        Text("•")
                            .foregroundColor(.accentColor)
                        Text(category)
                            .foregroundColor(.primary)
                    }
                }
            }
            .font(.body)
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        SearchCardView()
            .preferredColorScheme(.light)
        SearchCardView()
            .preferredColorScheme(.dark)
    }
}
