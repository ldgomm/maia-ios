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
    @State private var searchWorkItem: DispatchWorkItem?

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
                searchWorkItem?.cancel()
                let newWorkItem = DispatchWorkItem {
                    if newValue.count >= 4 {
                        viewModel.searchMainProductByKeywords(for: newValue)
                    }
                }
                searchWorkItem = newWorkItem
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: newWorkItem)
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
