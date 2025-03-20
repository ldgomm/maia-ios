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
        
    init() {
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
            .receive(on: DispatchQueue.main)
            .sink { (result: Result<[ProductDto], NetworkError>) in
                switch result {
                case .success(let success):
                    let loadedProducts = success.map { $0.toProduct() }
                    self.allProducts = loadedProducts
                    self.products = loadedProducts
                case .failure(let failure):
                    print(handleNetworkError(failure))
                }
            }
            .store(in: &cancellables)
    }
    
    func getProductByKeywords(for keywords: String) {
        let trimmed = keywords.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 1) If there's no input, restore the full list
        guard !trimmed.isEmpty else {
            restoreAllProducts()
            return
        }
        
        // 2) Single-term if search starts with a digit, otherwise split
        let firstCharIsDigit = trimmed.first?.isNumber ?? false
        let terms: [String]
        if firstCharIsDigit {
            // Keep entire string as one term
            terms = [trimmed.lowercased()]
        } else {
            // Split on spaces
            terms = trimmed
                .lowercased()
                .split(separator: " ")
                .map(String.init)
        }
        
        // 3) Compute how many terms each product matches
        let productsWithMatchCount = allProducts.map { product -> (product: Product, matchCount: Int) in
            let matchCount = terms.reduce(into: 0) { count, term in
                if fieldMatches(product, term: term) {
                    count += 1
                }
            }
            return (product, matchCount)
        }
        
        // 4) Filter products that match *all* terms (matchCount == terms.count)
        let matchingProducts = productsWithMatchCount
            .filter { $0.matchCount == terms.count }
        
        // 5) Sort descending by match count (optional — everything has the same count anyway)
        let sortedByMatches = matchingProducts.sorted { $0.matchCount > $1.matchCount }
        
        // 6) Update the published array
        products = sortedByMatches.map { $0.product }
    }

    // MARK: - fieldMatches

    /// Returns `true` if `product` matches the given `term`
    /// in *any* of the following fields:
    ///  - `name`, `label`, `owner`, `year` (case-insensitive substring),
    ///  - `model` (with spaces removed, also case-insensitive).
    private func fieldMatches(_ product: Product, term: String) -> Bool {
        let lowerTerm = term.lowercased()
        
        // 1) Check name, label, owner, year with normal substring matching
        let basicFields = [
            product.name.lowercased(),
            product.label?.lowercased() ?? "",
            product.owner?.lowercased() ?? "",
            product.year?.lowercased() ?? ""
        ]
        
        if basicFields.contains(where: { $0.contains(lowerTerm) }) {
            return true
        }
        
        // 2) Check the model, removing spaces from both
        let normalizedModel = product.model
            .lowercased()
            .replacingOccurrences(of: " ", with: "")
        
        let normalizedTerm = lowerTerm
            .replacingOccurrences(of: " ", with: "")
        
        return normalizedModel.contains(normalizedTerm)
    }
    
    func restoreAllProducts() {
        products = allProducts
    }
    
    /**
     This function retrieves a product from the server using its keywords.
     - Parameter keywords: The keywords of the product to retrieve.
     */
    func searchMainProductByKeywords(for keywords: String) {                
        searchMainProductByKeywordsUseCase.invoke(
            from: getUrl(endpoint: "maia-product/products", keywords: keywords)
        )
        .receive(on: DispatchQueue.main)
        .sink { (result: Result<[ProductDto], NetworkError>) in
            switch result {
            case .success(let success):
                let newProducts = success.map { $0.toProduct() }
                self.searchProducts = newProducts.filter { newProduct in
                    !self.products.contains(where: { $0.id == newProduct.id })
                }
            case .failure(let failure):
                print(handleNetworkError(failure))
            }
        }
        .store(in: &cancellables)
    }
    
    /**
     This function creates a new product on the server using the provided Product object.
     - Parameter product: The Product object to create.
     */
    func postProduct(product: Product,
                     onSuccess: @escaping (String) -> Void,
                     onFailure: @escaping (String) -> Void) throws {
        postProductUseCase.invoke(
            from: getUrl(endpoint: "maia-product"),
            with: PostProductRequest(product: product.toProductDto())
        )
        .receive(on: DispatchQueue.main)
        .sink { (result: Result<MessageResponse, NetworkError>) in
            switch result {
            case .success(let success):
                onSuccess(success.message)
            case .failure(let failure):
                onFailure(handleNetworkError(failure))
            }
        }
        .store(in: &cancellables)
    }
    
    /**
     This function updates a product on the server using the provided Product object.
     - Parameter product: The Product object to update.
     */
    func putProduct(product: Product,
                    onSuccess: @escaping (String) -> Void,
                    onFailure: @escaping (String) -> Void) throws {
        putProductUseCase.invoke(
            from: getUrl(endpoint: "maia-product"),
            with: PutProductRequest(product: product.toProductDto())
        )
        .receive(on: DispatchQueue.main)
        .sink { (result: Result<MessageResponse, NetworkError>) in
            switch result {
            case .success(let success):
                self.updateProduct(product)
                onSuccess(success.message)
            case .failure(let failure):
                onFailure(handleNetworkError(failure))
            }
        }
        .store(in: &cancellables)
    }
    
    func updateProduct(_ product: Product) {
        if let index = self.products.firstIndex(where: { $0.id == product.id }) {
            self.products.remove(at: index)
        }
    }
    
//    func addProduct(_ product: Product) {
//        self.products.append(product)
//    }
//    
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
        .receive(on: DispatchQueue.main)
        .sink { (result: Result<MessageResponse, NetworkError>) in
            switch result {
            case .success(let success):
                onSuccess(success.message)
                self.products.removeAll { $0.id == product.id }
            case .failure(let failure):
                onFailure(handleNetworkError(failure))
            }
        }
        .store(in: &cancellables)
    }
    
    func getCategories() {
        groups.removeAll()
        getGroupsUseCase.invoke(from: getUrl(endpoint: "data/groups"))
            .receive(on: DispatchQueue.main)
            .sink { (result: Result<[Group], NetworkError>) in
                switch result {
                case .success(let success):
                    self.groups = success
                case .failure(let failure):
                    print(handleNetworkError(failure))
                }
            }
            .store(in: &cancellables)
    }
}
