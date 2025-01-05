//
//  MaiaApp.swift
//  Maia
//
//  Created by José Ruiz on 1/11/24.
//

import Firebase
import SwiftData
import SwiftUI

@main
struct MaiaApp: App {
    @AppStorage("isAuthenticated") var isAuthenticated: Bool = false
    let container: ModelContainer
    @StateObject private var networkMonitor = NetworkMonitor()

    var body: some Scene {
        WindowGroup {
            if !networkMonitor.isConnected {
                NoInternetView()
            } else if isAuthenticated {
                ContentView(modelContext: container.mainContext)
            } else {
                AuthenticationView()
            }
        }
        .modelContainer(container)
    }
    
    init() {
        FirebaseApp.configure()
        do {
            container = try ModelContainer(for: MessageEntity.self)
        } catch {
            fatalError("Failed to create ModelContainer for Message.")
        }
        
        let _ = Singletons(container.mainContext)
    }
}
