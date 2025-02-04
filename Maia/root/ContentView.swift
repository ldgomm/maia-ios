//
//  ContentView.swift
//  Maia
//
//  Created by José Ruiz on 21/5/24.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @StateObject private var productViewModel: ProductViewModel
    @StateObject private var chatViewModel: ChatViewModel
    @StateObject private var settingsViewModel: SettingsViewModel
    
    var body: some View {
        TabView {
            ProductsView()
                .environmentObject(productViewModel)
                .tabItem { Label(LocalizedStringKey("my_products_navigation_title"), systemImage: "menucard") }
            SearchView()
                .environmentObject(productViewModel)
                .tabItem { Label(LocalizedStringKey("search_navigation_title"), systemImage: "magnifyingglass") }
            ChatsView()
                .environmentObject(chatViewModel)
                .tabItem { Label(LocalizedStringKey("chats_label"), systemImage: "message") }
            StoreView()
                .environmentObject(settingsViewModel)
                .tabItem { Label(LocalizedStringKey("profile_label"), systemImage: "person") }
        }
    }
    
    init(modelContext: ModelContext) {
        _productViewModel = StateObject(wrappedValue: ProductViewModel())
        _chatViewModel = StateObject(wrappedValue: ChatViewModel(modelContext: modelContext))
        _settingsViewModel = StateObject(wrappedValue: SettingsViewModel())
    }
}
