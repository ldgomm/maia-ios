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
    @State private var selectedMi: Mi? = nil {
        didSet {
            selectedNi = nil
            selectedXi = nil
        }
    }
    @State private var selectedNi: Ni? = nil {
        didSet {
            selectedXi = nil
        }
    }
    @State private var selectedXi: Xi? = nil
    
    @State private var hideFilterView: Bool = false
    @State private var previousScrollOffset: CGFloat = 0
    @State private var currentScrollOffset: CGFloat = 0
    
    var filteredProducts: [Product] {
        viewModel.products.filter { product in
            (selectedMi == nil || product.category.group == selectedMi?.name) &&
            (selectedNi == nil || product.category.domain == selectedNi?.name) &&
            (selectedXi == nil || product.category.subclass == selectedXi?.name)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack {
                        ForEach(filteredProducts.sorted { $0.date > $1.date }) { product in
                            ProductItemView(product: product)
                                .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
            }
            .refreshable {
                viewModel.getProducts()
            }
            .searchable(text: $searchText)
            .onChange(of: searchText) {
                viewModel.searchStoreProductByKeywords(for: $1)
            }
            .navigationTitle(LocalizedStringKey("my_products_navigation_title"))
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(for: Product.self) { product in
                ProductView(product: product)
                    .environmentObject(viewModel)
            }
        }
        .refreshable {
            viewModel.getProducts()
            viewModel.getCategories()
        }
    }
}
