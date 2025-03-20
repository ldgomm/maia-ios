//
//  ProductsView.swift
//  Sales
//
//  Created by José Ruiz on 4/4/24.
//

import SwiftUI

struct ProductsView: View {
    @EnvironmentObject var viewModel: ProductViewModel
    
    @State private var addProduct: Bool = false
    @State private var searchText: String = ""
    
    @State private var selectedGroup: Group? = nil
    @State private var selectedDomain: Domain? = nil
    @State private var selectedSubclass: Subclass? = nil
    
    @State private var searchWorkItem: DispatchWorkItem?
    
    var filteredProducts: [Product] {
        viewModel.products.filter { product in
            (selectedGroup == nil || product.category.group == selectedGroup?.name) &&
            (selectedDomain == nil || product.category.domain == selectedDomain?.name) &&
            (selectedSubclass == nil || product.category.subclass == selectedSubclass?.name)
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                FilterView(selectedGroup: $selectedGroup, selectedDomain: $selectedDomain, selectedSubclass: $selectedSubclass, groups: viewModel.groups, products: viewModel.products)
                LazyVStack(spacing: 8) {
                    ForEach(filteredProducts.sorted { $0.date > $1.date }) { product in
                        NavigationLink(value: product) {
                            ProductRowView(product: product)
                                .padding(.horizontal, 8)
                        }
                    }
                }
            }
            .refreshable {
                viewModel.getProducts()
                viewModel.getCategories()
            }
            .navigationTitle(LocalizedStringKey("my_products_navigation_title"))
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(for: Product.self) { product in
                ProductView(product: product)
                    .environmentObject(viewModel)
            }
            .searchable(text: $searchText)
            .onChange(of: searchText) { oldValue, newValue in
                searchWorkItem?.cancel()
                let newWorkItem = DispatchWorkItem {
                    if newValue.count >= 3 {
                        viewModel.getProductByKeywords(for: newValue)
                    } else {
                        viewModel.restoreAllProducts()
                    }
                }
                searchWorkItem = newWorkItem
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: newWorkItem)
            }
        }
    }
}
