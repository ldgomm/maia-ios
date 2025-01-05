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
        print("ViewModel | getProducts")
        getProductsUseCase.invoke(from: getUrl(endpoint: "maia-product"))
            .sink { (result: Result<[ProductDto], NetworkError>) in
                switch result {
                case .success(let success):
                    print("Success: \(success.count)")
                    success.forEach { print($0.id) }
                    self.products = success.map { $0.toProduct() }
                case .failure(let failure):
                    handleNetworkError(failure)
                }
            }.store(in: &cancellables)
    }
    
    /**
     This function retrieves a product from the server using its keywords.
     - Parameter keywords: The keywords of the product to retrieve.
     */
    func searchStoreProductByKeywords(for keywords: String) {
        guard !keywords.isEmpty else {
            getProducts()
            return
        }
        print("ViewModel | getProductByKeywords >> keywords: \(keywords)")
        
        searchStoreProductByKeywordsUseCase.invoke(
            from: getUrl(endpoint: "maia-product", keywords: keywords)
        )
        .sink { (result: Result<[ProductDto], NetworkError>) in
            switch result {
            case .success(let success):
                self.products = success.map { $0.toProduct() }
            case .failure(let failure):
                handleNetworkError(failure)
            }
        }
        .store(in: &cancellables)
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

