//
//  TermsOfUse.swift
//  Maia
//
//  Created by José Ruiz on 17/10/24.
//

import SwiftUI

struct TermsOfUseView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                // Section 1
                SettingsSectionView(title: "1. Introduction", content: """
                    Welcome to Maia, an application designed for store owners to manage their products, sales, and customer interactions within the Premier Dark Coffee platform. Maia is intended solely for authorized store owners, and access to the app is restricted to approved users.
                    """)
                
                // Section 2
                SettingsSectionView(title: "2. User Eligibility", content: """
                    The use of Maia is limited to store owners who are registered and approved by Premier Dark Coffee. Unauthorized use of the app is strictly prohibited.
                    """)
                
                // Section 3
                SettingsSectionView(title: "3. Authentication", content: """
                                        Authentication to Maia is handled through third-party services:
                                        """)
                VStack(alignment: .leading) {
                    BulletPointView(content: "Apple Sign-In (iOS): Users authenticate via their Apple credentials, ensuring secure access to the app without Maia storing login credentials.")
                    BulletPointView(content: "Google Sign-In (Android): Users authenticate via their Google credentials, similarly ensuring secure access without Maia retaining login data.")
                }.padding(.horizontal, 20)
                
                // Section 4
                SettingsSectionView(title: "4. Product Management and Updates", content: """
                    Store owners can manage and update product information, including images, descriptions, and prices. However, some areas of product information may be updated or modified by the administrator without the store’s explicit permission when necessary to ensure consistency or accuracy.
                    """)
                
                SettingsSectionView(title: "5. Image and Content Guidelines", content: """
                    When uploading product images, stores must ensure that:
                    """)
                VStack(alignment: .leading) {
                    BulletPointView(content: "Images are 1024x1024 pixels in size.")
                    BulletPointView(content: "FNo phone numbers, contact information, or other personal details are included outside of what the app provides.")
                }.padding(.horizontal, 20)
                Text("Stores should update product information only when strictly necessary, as existing information is considered valid. Improper updates or inclusion of unauthorized details may result in penalties or content removal.")
                
                // Section 6
                SettingsSectionView(title: "6. Communication with Clients", content: """
                    When chatting with clients through the app, stores must:
                    """)
                VStack(alignment: .leading) {
                    BulletPointView(content: "Be polite and professional at all times.")
                    BulletPointView(content: "Follow the same guidelines for content and image updates.")
                    BulletPointView(content: "Never request personal information from clients, as the system and app are designed to respect the absolute privacy of customers.")
                }.padding(.horizontal, 20)
                
                // Section 7
                SettingsSectionView(title: "7. Permitted Use", content: """
                    Users are granted non-transferable rights to access and use Maia exclusively for managing their store's products, handling sales, and communicating with customers on the Premier Dark Coffee platform. This includes:
                    """)
                
                VStack(alignment: .leading) {
                    BulletPointView(content: "Uploading and managing product details.")
                    BulletPointView(content: "Handling customer orders and inquiries.")
                    BulletPointView(content: "Managing store settings and configurations.")
                    BulletPointView(content: "Copying as many products as needed to manage the store effectively.")
                }.padding(.horizontal, 20)
                
                SettingsSectionView(title: "8. Confidentiality", content: """
                    As a user of Maia, you agree to maintain the confidentiality of all store-related data and any customer information you handle. Unauthorized disclosure of data accessed through the app is prohibited and may result in penalties or legal action.
                    """)
                
                SettingsSectionView(title: "9. Data Security", content: """
                    All interactions within Maia are secured using industry-standard encryption protocols (such as HTTPS). Users are responsible for ensuring that they access the app in a secure environment and do not share their authentication tokens or sensitive information with unauthorized parties.
                    """)
                
                SettingsSectionView(title: "10. Prohibited Activities", content: """
                    Users of Maia are prohibited from engaging in the following activities:
                    """)
                
                VStack(alignment: .leading) {
                    BulletPointView(content: "Attempting to bypass security measures or gain unauthorized access to data.")
                    BulletPointView(content: "Using the app for illegal activities or purposes not authorized by Premier Dark Coffee.")
                    BulletPointView(content: "Tampering with or reverse-engineering the Maia app.")
                }.padding(.horizontal, 20)
                
                SettingsSectionView(title: "11. Termination", content: """
                    Premier Dark Coffee reserves the right to revoke access to Maia at any time, without prior notice, in the event of misuse or unauthorized use. Access will also be terminated if a store's registration is revoked or closed.
                    """)
                
                SettingsSectionView(title: "12. Limitation of Liability", content: """
                    Maia is provided "as-is," without any warranties. Premier Dark Coffee is not responsible for data loss, security breaches, or other damages arising from the use or inability to use the app, except where required by law.
                    """)
                
                SettingsSectionView(title: "13. No Cost", content: """
                    The use of Maia is entirely free for store owners. There are no fees or costs associated with using the app to manage your store.
                    """)
                
                SettingsSectionView(title: "14. Updates to Terms", content: """
                    Premier Dark Coffee may update these Terms of Use from time to time. Any changes will only take effect when a new version of the app is published, ensuring that users will be able to review the updated terms natively within the app. Continued use of the app after updates signifies acceptance of the revised terms.
                    """)
                
                // Section 4: Contact Information
                Text("""
                    If you have any questions or need assistance, please contact us at terms@premierdarkcoffee.com.
                    """)
                .font(.body)
                .foregroundColor(.blue)
                .padding(.bottom, 10)
                
                SettingsSectionView(title: "15. Delayed Response Time", content: """
                    Please note that while we aim to respond to inquiries as quickly as possible, there may be instances when responses take a couple of days due to operational constraints.
                    """)
                
                // Footer
                Text("© 2024 Premier Dark Coffee. All Rights Reserved.")
                    .font(.footnote)
                    .padding(.top, 50)
            }
            .padding(.horizontal)
            .navigationTitle("Terms of Use")
        }
    }
}

#Preview {
    TermsOfUseView()
}
