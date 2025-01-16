//
//  ProductViewModel.swift
//  Sales
//
//  Created by José Ruiz on 3/4/24.
//

import Combine
import FirebaseAuth
import Foundation

final class ProductViewModel: ObservableObject {
    @Published private(set) var products: [Product] = []
    private var allProducts: [Product] = []
    
    @Published private(set) var searchProducts: [Product] = []
    @Published var groups: [Group] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    let getProductsUseCase: GetProductsUseCase = .init()
    let getProductByIdUseCase: GetProductByIdUseCase = .init()
    let searchStoreProductByKeywordsUseCase: SearchStoreProductByKeywordsUseCase = .init()
    let postProductUseCase: PostProductUseCase = .init()
    let putProductUseCase: PutProductUseCase = .init()
    let deleteProductUseCase: DeleteProductUseCase = .init()
    
    let searchMainProductByKeywordsUseCase: SearchProductByKeywordsUseCase = .init()
    let getGroupsUseCase: GetGroupsUseCase = .init()
    
    //    let user: String?
    
    init() {
        //        self.user = Auth.auth().currentUser?.uid
        getProducts()
        getCategories()
        
    }
    
    func removeAllProducts() {
        self.products.removeAll()
    }
    
    /**
     This function retrieves all products from the server.
     */
    func getProducts() {
        getProductsUseCase.invoke(from: getUrl(endpoint: "maia-product"))
            .sink { (result: Result<[ProductDto], NetworkError>) in
                switch result {
                case .success(let success):
                    let loadedProducts = success.map { $0.toProduct() }
                    self.allProducts = loadedProducts
                    self.products = loadedProducts
                case .failure(let failure):
                    handleNetworkError(failure)
                }
            }
            .store(in: &cancellables)
    }
    
    // Filter the array by multiple keywords across multiple fields
    func getProductByKeywords(for keywords: String) {
        // If there’s no input, restore the original full list
        guard !keywords.isEmpty else {
            restoreAllProducts()
            return
        }
        
        // Split input into separate search terms
        // e.g., "cronos bike black" -> ["cronos", "bike", "black"]
        let terms = keywords
            .lowercased()
            .split(separator: " ")
            .map(String.init)
        
        // 1) For each product, figure out how many of the 'terms' match
        let productsWithMatchCount = allProducts.map { product -> (product: Product, matchCount: Int) in
            let matchCount = terms.reduce(into: 0) { count, term in
                if fieldMatches(product, term: term) {
                    count += 1
                }
            }
            return (product, matchCount)
        }
        
        // 2) Filter out products that have zero matches
        //    (i.e., keep products with matchCount >= 1)
        let matchingProducts = productsWithMatchCount
            .filter { $0.matchCount > 0 }
        
        // 3) Sort the resulting products by matchCount, descending
        let sortedByMatches = matchingProducts.sorted { $0.matchCount > $1.matchCount }
        
        // 4) Extract just the Product objects in sorted order
        products = sortedByMatches.map { $0.product }
    }

    private func fieldMatches(_ product: Product, term: String) -> Bool {
        product.name.lowercased().contains(term)
        || (product.label?.lowercased().contains(term) ?? false)
        || product.description.lowercased().contains(term)
        || (product.owner?.lowercased().contains(term) ?? false)
        || product.model.lowercased().contains(term)
        // ... add more fields if needed
    }
    
    func restoreAllProducts() {
        products = allProducts
    }
    
    /**
     This function retrieves a product from the server using its keywords.
     - Parameter keywords: The keywords of the product to retrieve.
     */
    func searchMainProductByKeywords(for keywords: String) {
        print("Keywords called")
        guard !keywords.isEmpty else {
            getProducts()
            return
        }
        print("ViewModel | getProductByKeywords >> keywords: \(keywords)")
        
        searchMainProductByKeywordsUseCase.invoke(
            from: getUrl(endpoint: "maia-product/products", keywords: keywords)
        )
        .sink { (result: Result<[ProductDto], NetworkError>) in
            switch result {
            case .success(let success):
                let newProducts = success.map { $0.toProduct() }
                self.searchProducts = newProducts.filter { newProduct in
                    !self.products.contains(where: { $0.id == newProduct.id })
                }
            case .failure(let failure):
                handleNetworkError(failure)
            }
        }
        .store(in: &cancellables)
    }
    
    /**
     This function creates a new product on the server using the provided Product object.
     - Parameter product: The Product object to create.
     */
    func postProduct(product: Product) throws {
        postProductUseCase.invoke(
            from: getUrl(endpoint: "maia-product"),
            with: PostProductRequest(product: product.toProductDto())
        )
        .sink { (result: Result<MessageResponse, NetworkError>) in
            switch result {
            case .success(let data):
                print("Success adding product: \(data.message)")
            case .failure(let failure):
                handleNetworkError(failure)
            }
        }
        .store(in: &cancellables)
    }
    
    /**
     This function updates a product on the server using the provided Product object.
     - Parameter product: The Product object to update.
     */
    func putProduct(product: Product) throws {
        putProductUseCase.invoke(
            from: getUrl(endpoint: "maia-product"),
            with: PutProductRequest(product: product.toProductDto())
        )
        .sink { (result: Result<MessageResponse, NetworkError>) in
            switch result {
            case .success(let success):
                print(success)
            case .failure(let failure):
                handleNetworkError(failure)
            }
        }
        .store(in: &cancellables)
    }
    
    /**
     This function deletes a product from the server using its ID.
     - Parameter id: The ID of the product to delete.
     */
    func deleteProduct(
        product: Product,
        onSuccess: @escaping (String) -> Void,
        onFailure: @escaping (String) -> Void
    ) {
        deleteProductUseCase.invoke(
            from: getUrl(endpoint: "maia-product"),
            with: DeleteProductRequest(productId: product.id)
        )
        .sink { (result: Result<MessageResponse, NetworkError>) in
            switch result {
            case .success(let success):
                onSuccess(success.message)
                self.products.removeAll { $0.id == product.id }
            case .failure(let failure):
                handleNetworkError(failure)
            }
        }
        .store(in: &cancellables)
    }
    
    func getCategories() {
        groups.removeAll()
        getGroupsUseCase.invoke(from: getUrl(endpoint: "data/groups"))
            .sink { (result: Result<[Group], NetworkError>) in
                switch result {
                case .success(let success):
                    self.groups = success
                case .failure(let failure):
                    handleNetworkError(failure)
                }
            }
            .store(in: &cancellables)
    }
}

