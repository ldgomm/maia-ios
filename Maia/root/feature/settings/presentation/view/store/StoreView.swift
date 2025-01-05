//
//  StoreView.swift
//  Maia
//
//  Created by José Ruiz on 29/7/24.
//

import MapKit
import SwiftUI

func formatPhoneNumber(_ number: String) -> String {
        // Assuming the number starts with the country code
        if number.hasPrefix("+593") && number.count == 12 {
            let countryCode = "+593"
            let areaCode = number.dropFirst(3).prefix(2)
            let restOfNumber = number.dropFirst(5)
            return "\(countryCode) \(areaCode) \(restOfNumber.prefix(4)) \(restOfNumber.suffix(4))"
        } else {
            return number // Return the original if it doesn't match expected format
        }
    }

struct StoreView: View {
    @EnvironmentObject var viewModel: SettingsViewModel
    
    @State private var showSettings: Bool = false
    
    var body: some View {
        if let store = viewModel.store {
            NavigationView {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // Store Image
                        if let imageUrl = URL(string: store.image.url) {
                            CachedAsyncImage(url: imageUrl) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .frame(width: 50, height: 50)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .clipShape(RoundedRectangle(cornerRadius: 11))
                                        .frame(maxWidth: .infinity, maxHeight: 300)
                                        .padding(.horizontal)
                                case .failure:
                                    Image(systemName: "photo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .clipShape(RoundedRectangle(cornerRadius: 11))
                                        .frame(maxWidth: .infinity, maxHeight: 300)
                                        .padding(.horizontal)
                                        .foregroundColor(.gray)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        }
                        // Address
                        SectionView(title: "Address") {
                            Text("\(store.address.street), \(store.address.city), \(store.address.state) \(store.address.zipCode), \(store.address.country)")
                        }
                        
                        Section {
                            let location2d = CLLocationCoordinate2D(latitude: store.address.location.coordinates[1], longitude: store.address.location.coordinates[0])
                            MapView(location: location2d)
                        }
                        .frame(height: 300)
                        .clipShape(RoundedRectangle(cornerRadius: 11))
                        .padding()
                        
                        SectionView(title: "Phone number") {
                            Text("📞 (+593) \(store.phoneNumber)")
                        }
                        
                        SectionView(title: "Email Address") {
                            Text("✉️ \(store.emailAddress)")
                        }
                        
                        // Website
                        SectionView(title: "Website") {
                            Text(store.website)
                        }
                        
                        Divider()
                        
                        SectionView(title: "Description") {
                            Text(store.description)
                        }
                        
                        SectionView(title: "Return Policy") {
                            Text(store.returnPolicy)
                        }
                        
                        SectionView(title: "Refund Policy") {
                            Text(store.refundPolicy)
                        }
                        
                        SectionView(title: "Brands") {
                            Text(store.brands.joined(separator: ", "))
                        }
                        
                        Divider()
                        
                        // Status
                        SectionView(title: "Status") {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Status")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                statusView(status: store.status)
                                    .padding(.bottom, 10)
                            }
                        }
                    }
                    .navigationTitle(store.name)
                    .navigationBarTitleDisplayMode(.large)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Settings", systemImage: "gear") {
                                self.showSettings.toggle()
                            }
                        }
                    }
                    .sheet(isPresented: $showSettings) {
                        SettingsView()
                            .environmentObject(viewModel)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
    
    private func statusView(status: Status) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            if status.isActive { statusLabel(text: "Active", color: .green) }
            if status.isVerified { statusLabel(text: "Verified", color: .green) }
            if status.isPromoted { statusLabel(text: "Promoted", color: .blue) }
            if status.isSuspended { statusLabel(text: "Suspended", color: .red) }
            if status.isClosed { statusLabel(text: "Closed", color: .gray) }
            if status.isPendingApproval { statusLabel(text: "Pending Approval", color: .yellow) }
            if status.isUnderReview { statusLabel(text: "Under Review", color: .purple) }
            if status.isOutOfStock { statusLabel(text: "Out of Stock", color: .black) }
            if status.isOnSale { statusLabel(text: "On Sale", color: .pink) }
        }
    }
    
    private func statusLabel(text: String, color: Color) -> some View {
        Text(text)
            .font(.subheadline)
            .fontWeight(.bold)
            .foregroundColor(color)
    }
}
