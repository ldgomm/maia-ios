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
    
    @State private var hideFilterView: Bool = false
    @State private var previousScrollOffset: CGFloat = 0
    @State private var currentScrollOffset: CGFloat = 0
    
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
            VStack {
                if !hideFilterView {
                    FilterView(selectedGroup: $selectedGroup, selectedDomain: $selectedDomain, selectedSubclass: $selectedSubclass, groups: viewModel.groups, products: viewModel.products)
                        .transition(.move(edge: .top))
                        .animation(.easeInOut, value: hideFilterView)
                }
                
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(filteredProducts.sorted { $0.date > $1.date }) { product in
                            NavigationLink(value: product) {
                                ProductRowView(product: product)
                                    .padding(.horizontal, 8)
                            }
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle(LocalizedStringKey("my_products_navigation_title"))
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(for: Product.self) { product in
                ProductView(product: product)
                    .environmentObject(viewModel)
            }
            .refreshable {
                viewModel.getProducts()
                viewModel.getCategories()
            }
            .searchable(text: $searchText)
            .onChange(of: searchText) { oldValue, newValue in
                // Cancel the previous scheduled work item (if any) to avoid spamming filters
                searchWorkItem?.cancel()
                
                let newWorkItem = DispatchWorkItem {
                    if newValue.count >= 3 {
                        // Only filter when user has typed 3 or more characters
                        viewModel.getProductByKeywords(for: newValue)
                    } else {
                        // If fewer than 3 chars (or empty), restore the full list
                        viewModel.restoreAllProducts()
                    }
                }
                
                searchWorkItem = newWorkItem
                // Debounce for 1 second (adjust as needed)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: newWorkItem)
            }
        }
    }
}
