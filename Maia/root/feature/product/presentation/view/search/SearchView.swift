//
//  SearchView.swift
//  Maia
//
//  Created by José Ruiz on 7/6/24.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var viewModel: ProductViewModel
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.searchProducts.isEmpty {
                    SearchCardView()
                        .padding()
                        .transition(.opacity)
                }
                
                List {
                    ForEach(viewModel.searchProducts) { product in
                        NavigationLink(value: product) {
                            HStack {
                                if !product.image.url.isEmpty {
                                    CachedAsyncImage(url: URL(string: product.image.url)!) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                                .frame(width: 50, height: 50)
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 50, height: 50)
                                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                        case .failure:
                                            Image(systemName: "photo")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 50, height: 50)
                                                .foregroundColor(.gray)
                                        @unknown default:
                                            EmptyView()
                                        }
                                    }
                                }
                                VStack(alignment: .leading) {
                                    Text(product.name)
                                        .font(.headline)
                                        .bold()
                                    Text(product.label ?? "")
                                        .font(.caption2)
                                        .foregroundStyle(.secondary)        
                                    Text(product.owner ?? "")
                                        .font(.caption2)
                                        .foregroundStyle(.secondary)
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                }
            }
            .searchable(text: $searchText)
            .onChange(of: searchText) { _, newValue in
                // 1) Split into words
                let words = newValue
                    .split(separator: " ")
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }

                // 2) Filter for words of length > 4
                let filteredWords = words.filter { $0.count >= 4 }

                // 3) If there's at least one long-enough word, call the search method
                if !filteredWords.isEmpty {
                    // Join them back into a string if needed by your backend
                    let joinedWords = filteredWords.joined(separator: " ")
                    viewModel.searchMainProductByKeywords(for: joinedWords)
                } else {
                    // You can decide what to do otherwise, e.g. clear results, do nothing, etc.
                }
            }

            .navigationTitle(LocalizedStringKey("search_navigation_title"))
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(for: Product.self) { product in
                ProductView(product: product)
                    .environmentObject(viewModel)
            }
        }
    }
}
