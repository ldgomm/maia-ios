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
                
                // Section 1: Deletion Process
                Text("""
                    If you wish to delete your account in Maia, you can do so within the app by navigating to the Settings section. In the Configurations menu, you will find an option to request the deletion of your account.
                    """)
                .font(.body)
                
                // Section 2: Important Note
                Text("""
                    Please note: Deleting your account is an irreversible action. This process will permanently delete your account, including all store data and products associated with your account. Once deleted, this information cannot be recovered.
                    """)
                .font(.body)
                .fontWeight(.bold)
                
                // Section 3: Backup Recommendation
                Text("""
                    Before proceeding with account deletion, we recommend that you ensure you have backed up any necessary data or information, as we will not be able to restore it once the deletion process is completed.
                    """)
                .font(.body)
                
                // Section 4: Contact Information
                Text("""
                    If you have any questions or need assistance, please contact us at account@premierdarkcoffee.com.
                    """)
                .font(.body)
                .foregroundColor(.blue)
                
                // Section 5: Response Time Notice
                Text("""
                    Please note that while we strive to respond to all inquiries as quickly as possible, there may be times when responses take a couple of days to be attended due to operational constraints. We appreciate your patience and understanding.
                    """)
                .font(.body)
                
                // Footer
                Text("© 2024 Maia, Premier Dark Coffee. All Rights Reserved.")
                    .font(.footnote)
                    .padding(.top, 50)
            }
            .padding(.horizontal)
            .navigationTitle("Account Deletion")
        }
    }
}
