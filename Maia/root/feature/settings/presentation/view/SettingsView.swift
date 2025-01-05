//
//  SettingsView.swift
//  Maia
//
//  Created by José Ruiz on 7/6/24.
//

import FirebaseAuth
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: SettingsViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    NavigationLink("Privacy Policy", destination: PrivacyPolicyView())
                    NavigationLink("Terms of Use", destination: TermsOfUseView())
                    NavigationLink("Account Deleteion", destination: AccountDeletionView())
                }
                Section {
                    Button("Log Out") {
                        logOut()
                    }
                    .foregroundColor(.red) // To give the log-out button a prominent red color
                }
            }
            .navigationTitle("Settings")
        }
    }
    
    // Helper function for log out
    private func logOut() {
        // Try to sign out of Firebase
        do {
            try Auth.auth().signOut()
            KeychainHelper.shared.delete(forKey: "jwt")
            UserDefaults.standard.set(false, forKey: "isAuthenticated")
        } catch {
            print("Error signing out: \(error.localizedDescription)")
            // Optionally show an alert or message to the user about the failure
        }
    }
}

