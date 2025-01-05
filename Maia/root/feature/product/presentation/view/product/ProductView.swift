//
//  ProductView.swift
//  Sales
//
//  Created by José Ruiz on 13/4/24.
//

import FirebaseStorage
import SwiftUI

struct ProductView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var viewModel: ProductViewModel
    
    @State private var editProduct: Bool = false
    @State private var showAlert: Bool = false
    
    let product: Product
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let imageUrl = URL(string: product.image.url) {
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
                
                SectionView(title: NSLocalizedString("price_label", comment: "")) {
                    HStack {
                        if product.price.offer.isActive {
                            Text("\(product.price.amount, format: .currency(code: product.price.currency))")
                                .font(.caption)
                                .strikethrough()
                                .foregroundColor(.secondary)
                            Spacer()
                            if product.price.offer.discount > 0 {
                                Text("\(Int(product.price.offer.discount))% OFF")
                                    .font(.caption)
                                    .padding(5)
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .cornerRadius(5)
                                    .padding(.trailing, 5)
                                let discount = Double(product.price.offer.discount) / 100.0
                                let discountedPrice = product.price.amount * (1.0 - discount)
                                Text("\(discountedPrice, format: .currency(code: product.price.currency))")
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                            }
                        } else {
                            Text(product.price.amount, format: .currency(code: product.price.currency))
                                .font(.subheadline)
                                .foregroundColor(.primary)
                        }
                    }
                }
                
                SectionView(title: NSLocalizedString("label_label", comment: "")) {
                    Text("\(product.label ?? "")")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                }
                
                if let year = product.year, let owner = product.owner {
                    SectionView(title: NSLocalizedString("owner_label", comment: "")) {
                        Text("\(owner), \(year)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                    }
                }
                
                if product.model.count > 3 {
                    SectionView(title: NSLocalizedString("model_label", comment: "")) {
                        Text("\(product.model)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                    }
                }
                
                SectionView(title: NSLocalizedString("description_label", comment: "")) {
                    HStack(alignment: .center) {
                        Text(product.description)
                        Spacer()
                    }
                }
                
                if !product.overview.isEmpty {
                    SectionView(title: NSLocalizedString("information_label", comment: "")) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(product.overview) { information in
                                    InformationCardView(information: information)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                
                SectionView(title: NSLocalizedString("details_label", comment: "")) {
                    VStack(alignment: .leading, spacing: 8) {
                        ProductDetailRow(label: NSLocalizedString("stock_label", comment: ""), value: "\(product.stock)")
                        ProductDetailRow(label: NSLocalizedString("origin_label", comment: ""), value: product.origin)
                        if let keywords = product.keywords {
                            ProductDetailRow(label: NSLocalizedString("keywords_label", comment: ""), value: keywords.joined(separator: ", "))
                        }
                    }
                }
                
                if let specifications = product.specifications {
                    SectionView(title: NSLocalizedString("specifications_label", comment: "")) {
                        VStack(alignment: .leading, spacing: 8) {
                            ProductDetailRow(label: NSLocalizedString("colours_label", comment: ""), value: specifications.colours.joined(separator: ", "))
                            if let finished = specifications.finished {
                                ProductDetailRow(label: NSLocalizedString("finished_label", comment: ""), value: finished)
                            }
                            if let inBox = specifications.inBox {
                                ProductDetailRow(label: NSLocalizedString("in_box_label", comment: ""), value: inBox.joined(separator: ", "))
                            }
                            if let size = specifications.size {
                                ProductDetailRow(label: NSLocalizedString("size_label", comment: ""), value: "\(size.width)x\(size.height)x\(size.depth) \(size.unit)")
                            }
                            if let weight = specifications.weight {
                                ProductDetailRow(label: NSLocalizedString("weight_label", comment: ""), value: "\(weight.weight) \(weight.unit)")
                            }
                        }
                    }
                }
                
                if let warranty = product.warranty {
                    SectionView(title: NSLocalizedString("warranty_label", comment: "")) {
                        ProductDetailRow(label: String(format: NSLocalizedString("for_months_label", comment: ""), warranty.months), value: warranty.details.joined(separator: ", "))
                    }
                }
                
                if let legal = product.legal {
                    SectionView(title: NSLocalizedString("legal_label", comment: "")) {
                        Text(legal)
                    }
                }
                
                if let warning = product.warning {
                    SectionView(title: NSLocalizedString("warning_label", comment: "")) {
                        Text(warning)
                    }
                }
            }
            .navigationTitle(product.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button {
                    editProduct.toggle()
                } label: {
                    Label("Edit", systemImage: "pencil")
                }
                if product.image.belongs {
                    Button {
                        showAlert.toggle()
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
            .sheet(isPresented: $editProduct) {
                AddEditProductView(product: product, popToRoot: { dismiss() })
                    .environmentObject(viewModel)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text(LocalizedStringKey("delete_product_title")),
                      message: Text(LocalizedStringKey("delete_product_message")),
                      primaryButton: .destructive(Text(LocalizedStringKey("delete_button"))) {
                    print("Delete called")

                    if let path = product.image.path, shouldDeletePath(path: path) {
                        if let path = product.image.path, !path.isEmpty {
                            deleteImageFromFirebase(for: path) {
                                print("Main image deleted")
                            }
                        }
                        viewModel.deleteProduct(product: product) { message in
                            print("In view product deleted: \(message)")
                        } onFailure: { failure in
                            print("Failure: \(failure)")
                        }
                        dismiss()
                    } else {
                        print("Error deleting product")
                    }
                },
                      secondaryButton: .cancel(Text(LocalizedStringKey("cancel_button"))))
            }
        }
    }
}
