//
//  SettingsViewModel.swift
//  Maia
//
//  Created by José Ruiz on 23/7/24.
//

import Combine
import FirebaseAuth
import Foundation

class SettingsViewModel: ObservableObject {
    @Published private(set) var store: Store?
    
    private var cancellables: Set<AnyCancellable> = []

    var getStoreByIdUseCase: GetStoreByIdUseCase = .init()
//    let user: String?
    
    init() {
//        self.user = Auth.auth().currentUser?.uid
        getStore()
    }
    
    func getStore() {
        getStoreByIdUseCase.invoke(from: getUrl(endpoint: "maia"))
            .sink { (result: Result<StoreDto, NetworkError>) in
                switch result {
                case .success(let store):
                    self.store = store.toStore()
                case .failure(let failure):
                    print("Error getting store: \(failure.localizedDescription)")
                }
            }
            .store(in: &cancellables)
    }
}
