//
//  ExpandedInformationView.swift
//  Maia
//
//  Created by José Ruiz on 29/7/24.
//

import SwiftUI

struct ExpandedInformationView: View {
    let information: Information

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let imageUrl = URL(string: information.image.url) {
                    CachedAsyncImage(url: imageUrl) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: 50, height: 50)
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: .infinity, maxHeight: 300)
                                .padding(.horizontal)
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: .infinity, maxHeight: 300)
                                .padding(.horizontal)
                                .foregroundColor(.gray)
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
                Text(information.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 8)
                Text(information.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(information.description)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
    }
}
