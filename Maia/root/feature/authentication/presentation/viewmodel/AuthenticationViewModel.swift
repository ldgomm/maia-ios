//
//  AuthenticationViewModel.swift
//  Maia
//
//  Created by José Ruiz on 7/6/24.
//

import Combine
import CryptoKit
import Firebase
import FirebaseAuth
import Foundation

class AuthenticationViewModel: ObservableObject {
    
    var createStoreUseCase: CreateStoreUseCase = .init()
    var cancellables: Set<AnyCancellable> = []
    
    @Published var isAuthenticated: Bool = false
    @Published var isLoading: Bool = false

    func signIn(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
            // Validate email format
            guard isValidEmail(email) else {
                completion(false, "Invalid email address.")
                return
            }
            
            guard !password.isEmpty else {
                completion(false, "Password cannot be empty.")
                return
            }

            isLoading = true
            Task {
                do {
                    let result = try await Auth.auth().signIn(withEmail: email, password: password)
                    DispatchQueue.main.async { [self] in
                        self.isLoading = false
                        self.isAuthenticated = true
                        if result.user.uid != "" {
                            print("Success to login")
                            handleStoreCreation(result.user.uid, name: "Store name", completion: completion)
                        }
                        print("User signed in: \(result.user.email ?? "Unknown Email")")
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.isAuthenticated = false
                        completion(false, error.localizedDescription)
                        print("Error signing in: \(error.localizedDescription)")
                    }
                }
            }
        }

        // Helper function to validate email format
        private func isValidEmail(_ email: String) -> Bool {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
            return emailPred.evaluate(with: email)
        }
    
    private func handleStoreCreation(_ id: String, name: String?, completion: @escaping (Bool, String?) -> Void) {
        createStoreUseCase.invoke(from: getUrl(endpoint: "cronos-store"), for: PostStoreRequest(store: getFakeStore(id, name: name)))
            .sink { (result: Result<LoginResponse, NetworkError>) in
                switch result {
                case .success(let success):
                    print(success.token)
                    KeychainHelper.shared.save(success.token, forKey: "jwt")
                    UserDefaults.standard.set(true, forKey: "isAuthenticated")
                    completion(true, nil)
                    //Manage sign out pending
                case .failure(let failure):
                    completion(false, failure.localizedDescription)
                    handleNetworkError(failure)
                }
            }
            .store(in: &cancellables)
    }
}

func getFakeStore(_ id: String, name: String?) -> StoreDto {
    return StoreDto(id: id,
                    name: name ?? "iOS Store",
                    image: ImageDto(path: nil, url: "", belongs: true),
                    address: AddressDto(street: "Avenida de los Shyris",
                                        city: "Quito",
                                        state: "Pichincha",
                                        zipCode: "EC170109",
                                        country: "Ecuador",
                                        location: GeoPointDto(type: "Point", coordinates: [-78.486043, -0.192202])),
                    phoneNumber: "0987654321",
                    emailAddress: "",
                    website: "www.example.com",
                    description: "Commerce store",
                    returnPolicy: "Return policy",
                    refundPolicy: "Refund policy",
                    brands: ["Apple", "Samsung"],
                    createdAt: Date().currentTimeMillis(),
                    status: StatusDto(isActive: false, isVerified: false, isPromoted: false, isSuspended: false, isClosed: false, isPendingApproval: false, isUnderReview: false, isOutOfStock: false, isOnSale: false))
}
<<<<<<< HEAD
=======


/*
// Retrieving JWT from Keychain
if let token = KeychainHelper.shared.read(forKey: "jwt") {
    print("Token retrieved: \(token)")
}

// Deleting JWT from Keychain
KeychainHelper.shared.delete(forKey: "jwt")
*/
>>>>>>> 9bc6309cbc839293cadf9f509dceb149676dd5c0
