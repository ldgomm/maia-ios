//
//  AccountDeletionView.swift
//  Maia
//
//  Created by José Ruiz on 18/10/24.
//

import SwiftUI

struct AccountDeletionView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                // Title
                Text("Account Deletion")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.top)

                // Section 1: Deletion Policy
                Text("""
                Maia accounts are created manually by our admin team. To ensure the security and integrity of account data—especially with multiple-device access—users must request account deletion directly.
                """)
                .font(.body)

                // Section 2: How to Request Deletion
                Text("""
                If you wish to request the deletion of your account or personal data, please contact our support team by sending an email to:
                """)
                .font(.body)

                Text("support@premierdarkcoffee.com")
                    .font(.body)
                    .foregroundColor(.blue)
                    .underline()

                // Section 3: Important Notice
                Text("""
                ⚠️ Please note: Account deletion is permanent and cannot be undone. All account information, including any associated data, will be permanently removed once verified.
                """)
                .font(.body)
                .fontWeight(.bold)

                // Section 4: Security and Verification
                Text("""
                For security purposes and to prevent unauthorized deletion, all requests must be verified manually by our support team. This helps ensure data privacy and avoid misunderstandings, especially on shared accounts or multiple-device logins.
                """)
                .font(.body)

                // Section 5: Response Time
                Text("""
                We aim to respond to all account deletion requests as quickly as possible. Please allow up to 48 hours for a response due to operational flow.
                """)
                .font(.body)

                // Footer
                Text("© 2025 Maia, Premier Dark Coffee. All Rights Reserved.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding(.top, 50)
            }
            .padding(.horizontal)
        }
        .navigationTitle("Account Deletion")
    }
}
