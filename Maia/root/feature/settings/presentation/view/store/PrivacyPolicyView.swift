//
//  PrivacyPolicyView.swift
//  Maia
//
//  Created by José Ruiz on 18/10/24.
//

import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                // Section 1: Introduction
                SettingsSectionView(title: "1. Introduction", content: """
                    Welcome to the Store Application. We are committed to protecting the data related to your store and products. This Privacy Policy explains how we collect, use, and safeguard your information when you use our platform. Please review it carefully, and contact us if you have any questions or concerns.
                    """)
                
                // Section 2: Information We Collect
                SettingsSectionView(title: "2. Information We Collect", content: """
                    We collect the following types of information to provide and improve our services:
                    """)
                
                VStack(alignment: .leading) {
                    BulletPointView(content: "Store Information: When you manage your store through the application, we collect details such as store name, location, contact information, and operating hours.")
                    BulletPointView(content: "Product Information: We collect information about the products you upload to your store, including product names, descriptions, images, prices, and availability.")
                    BulletPointView(content: "Communication Data: We collect data from conversations between store owners and customers conducted through the app for customer service purposes.")
                }.padding(.horizontal, 20)
                
                // Section 3: Authentication
                SettingsSectionView(title: "3. Authentication", content: """
                    Authentication for the Store Application is handled securely through:
                    """)
                
                VStack(alignment: .leading) {
                    BulletPointView(content: "Apple Sign-In (iOS): Administrators and store owners authenticate using their Apple credentials. No login information is stored by the app itself.")
                    BulletPointView(content: "Google Sign-In (Android): Administrators and store owners authenticate using their Google credentials, ensuring secure access without storing user login information.")
                }.padding(.horizontal, 20)
                
                // Section 4: How We Use Your Information
                SettingsSectionView(title: "4. How We Use Your Information", content: """
                    We use your store and product information to:
                    """)
                
                VStack(alignment: .leading) {
                    BulletPointView(content: "Provide access to the app's features for managing your store and products.")
                    BulletPointView(content: "Display relevant product information to customers on the platform.")
                    BulletPointView(content: "Facilitate communication between store owners and customers in real-time.")
                }.padding(.horizontal, 20)
                
                // Section 5: Sharing of Your Information
                SettingsSectionView(title: "5. Sharing of Your Information", content: """
                    We do not sell or share your store information with third parties, except in the following cases:
                    """)
                
                VStack(alignment: .leading) {
                    BulletPointView(content: "Legal Requirements: If required by law, we may disclose your information to comply with legal obligations.")
                    BulletPointView(content: "Service Providers: We may share your information with service providers who help maintain and improve the platform. These providers are contractually obligated to protect your data.")
                    BulletPointView(content: "Business Transfers: If the platform is involved in a merger, acquisition, or sale, your information may be transferred as part of the transaction.")
                }.padding(.horizontal, 20)
                
                // Section 6: Data Security
                SettingsSectionView(title: "6. Data Security", content: """
                    We use industry-standard security measures to protect your store and product data. All data transmitted between your device and our servers is encrypted using HTTPS, ensuring secure transmission. We also use security protocols, such as JWT (JSON Web Tokens), for authentication management. While we make every effort to protect your data, no system is completely secure, and we are continuously improving our security measures.
                    """)
                
                // Section 7: Data Retention
                SettingsSectionView(title: "7. Data Retention", content: """
                    We will retain your store and product information for as long as necessary to provide our services or as required by law. If you decide to delete your store or remove your data, all information will be permanently deleted unless we are required by law to retain it.
                    """)
                
                // Section 8: Your Privacy Rights
                SettingsSectionView(title: "8. Your Privacy Rights", content: """
                    As a store owner, you have the following rights:
                    """)
                
                VStack(alignment: .leading) {
                    BulletPointView(content: "Access: You can request access to the data we have collected about your store and products.")
                    BulletPointView(content: "Correction: If any of your store or product information is incorrect, you can update it directly within the app.")
                    BulletPointView(content: "Deletion: You can request that we delete your store and product data from our systems.")
                }.padding(.horizontal, 20)
                
                // Section 9: Changes to This Policy
                SettingsSectionView(title: "9. Changes to This Policy", content: """
                    We may update this Privacy Policy from time to time to reflect changes in the application or legal requirements. You will be notified of any significant changes through the app or email. Continued use of the platform following any updates signifies your acceptance of the revised policy.
                    """)
                
                
                // Section 11: Update Visibility
                SettingsSectionView(title: "11. Changes to This Policy", content: """
                    Any changes to this policy will only take effect once a new update of the Maia app is published. This ensures that all users will be able to view the updated policy natively within the application. We encourage you to keep your app updated to stay informed of any changes.
                    """)
                
                // Section 4: Contact Information
                Text("""
                    If you have any questions or need assistance, please contact us at privacy@premierdarkcoffee.com.
                    """)
                .font(.body)
                .foregroundColor(.blue)
                .padding(.bottom, 10)
                
                // Section 12: Response Time
                SettingsSectionView(title: "12. Response Time", content: """
                    Please note that while we strive to respond to all inquiries as quickly as possible, there may be times when responses take a couple of days to be attended due to operational constraints. We appreciate your patience and understanding.
                    """)
                
                // Footer
                Text("© 2024 Maia, Premier Dark Coffee. All Rights Reserved.")
                    .font(.footnote)
                    .padding(.top, 50)
            }
            .padding(.horizontal)
            .navigationTitle("Privacy Policy")
        }
    }
}
