//
//  AddProductView.swift
//  Sales
//
//  Created by José Ruiz on 3/4/24.
//

import FirebaseAuth
import FirebaseStorage
import PhotosUI
import SwiftUI

struct AddEditProductView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var viewModel: ProductViewModel
    
    @State private var name: String = "" //Done
    @State private var label: String = "" //Done
    @State private var owner: String = "" //Done
    @State private var year: String?
    
    @State private var model: String = "" //Done
    @State private var description: String = "" //Done
    
    @State private var group: String = "" //Done
    @State private var domain: String = "" //Done
    @State private var subclass: String = "" //Done
    
    @State private var stock: Int = 10 //Done
    
    @State private var image: UIImage? = .init(systemName: "photo")
    @State private var photosPickerItem: PhotosPickerItem?
    @State private var oldMainImagePath: String? = ""
    @State private var oldMainImageUrl: String = ""
    @State private var mainImageHasChanged: Bool = false
    
    @State private var oldMainImageBelongs: Bool = false
    
    @State private var origin: String = "" //Done
    
    @State private var overview: [Information] = []
    @State private var overviewResult: [InformationResult] = []
    @State private var addInformation: Bool = false
    
    @State private var keywords: [String] = []
    @State private var word: String = ""
    
    @State private var specifications: Specifications?
    @State private var addSpecifications: Bool = false
    
    @State private var codes: Codes?
    
    @State private var warranty: String?
    
    @State private var legal: String? //Done
    @State private var warning: String? //Done
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @State private var informationResult: InformationResult? = nil
    @State private var updateInformationResult: Bool = false
    
    // New state variables for price, offer, and credit card
    @State private var priceAmount: String = ""
    @State private var priceCurrency: String = "USD"
    @State private var offerIsActive: Bool = true
    @State private var offerDiscount: Int = 10
    @State private var creditCardWithInterest: Int = 12
    @State private var creditCardWithoutInterest: Int = 3
    @State private var creditCardFreeMonths: Int = 0
    
    // State variables for upload progress
    @State private var uploadProgress: Double = 0.0
    @State private var isUploading = false
    
    @State private var showRequestAlert = false
    @State private var alertRequestMessage = ""
    
    let user: String
    
    var product: Product
    var popToRoot: () -> Void
    
    var body: some View {
        // Filtering categories based on main category and subcategory
//        let nis = categories.filter { $0.key.name == mi }.map { $1.self }.first ?? [:]
//        let xis = nis.filter { $0.key.name == ni }.map { $1.self }.first ?? []
        
        NavigationView {
            Form {
                // Image section
                Section {
                    PhotosPicker(selection: $photosPickerItem, matching: .images) {
                        Image(uiImage: image ?? UIImage(systemName: "photo")!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerRadius: 11))
                            .frame(maxWidth: .infinity, maxHeight: 300)
                            .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                // General information section
                Section {
                    TextField(LocalizedStringKey("name_label"), text: $name, prompt: Text(LocalizedStringKey("name_prompt")))
                        .autocapitalization(.none)
                        .disableAutocorrection(true)

                    TextField(LocalizedStringKey("label_label"), text: $label, prompt: Text(LocalizedStringKey("label_prompt")))
                        .autocapitalization(.none)
                        .disableAutocorrection(false)
                    
//                    TextField(LocalizedStringKey("owner_label"), text: $owner, prompt: Text(LocalizedStringKey("owner_prompt")))
//                        .autocapitalization(.none)
//                        .disableAutocorrection(false)
//                        .disabled(true)
                    
                    TextField(
                        NSLocalizedString("year_label", comment: ""),
                        text: Binding(
                            get: { self.year ?? "" },
                            set: { self.year = $0 }
                        ),
                        prompt: Text(NSLocalizedString("year_label", comment: ""))
                    )
                    .autocapitalization(.none)
                    .disableAutocorrection(false)
                    
//                    TextField(LocalizedStringKey("model_label"), text: $model, prompt: Text(LocalizedStringKey("model_prompt")))
//                        .autocapitalization(.none)
//                        .disableAutocorrection(true)
//                        .disabled(true)

//                    Picker(LocalizedStringKey("origin_label"), selection: $origin) {
//                        ForEach(madeIn, id: \.self) { country in
//                            Text(country)
//                        }
//                    }.disabled(true)

                } header: {
                    Text(LocalizedStringKey("general_information_header"))
                }
                
                Section {
                    VStack(alignment: .leading) {
                        Text(LocalizedStringKey("description_label"))
                            .font(.headline)
                        TextEditor(text: $description)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .frame(height: 100)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5), lineWidth: 0.5))
                    }
                }


                
                // Price Section
                Section {
                    TextField(NSLocalizedString("amount", comment: ""), text: $priceAmount)
                        .keyboardType(.decimalPad)
                    Picker(NSLocalizedString("currency", comment: ""), selection: $priceCurrency) {
                        ForEach(["USD", "EUR", "GBP"], id: \.self) {
                            Text($0)
                        }
                    }
                    
                    Toggle(NSLocalizedString("is_active", comment: ""), isOn: $offerIsActive)
                    Stepper("\(NSLocalizedString("discount", comment: "")): \(offerDiscount)%", value: $offerDiscount, in: 0...100, step: 1)
                    Stepper("\(NSLocalizedString("without_interest", comment: "")): \(creditCardWithoutInterest) months", value: $creditCardWithoutInterest, in: 0...24, step: 1)
                    Stepper("\(NSLocalizedString("with_interest", comment: "")): \(creditCardWithInterest) months", value: $creditCardWithInterest, in: 3...48, step: 1)
                    Stepper("\(NSLocalizedString("free_months", comment: "")): \(creditCardFreeMonths) months", value: $creditCardFreeMonths, in: 0...12, step: 1)
                } header: {
                    Text(NSLocalizedString("price", comment: ""))
                }
                
                Section {
                    Stepper("\(NSLocalizedString("units_of_product", comment: "")): \(stock)", value: $stock, in: 1...100, step: 1)
                } header: {
                    Text(NSLocalizedString("stock", comment: ""))
                }

                Section {
                    HStack {
                        TextField(LocalizedStringKey("keywords_label"), text: $word, prompt: Text(LocalizedStringKey("enter_keywords_prompt")))
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                        Button(action: addKeyword) {
                            Text(LocalizedStringKey("add_label"))
                        }
                        .disabled(word.isEmpty)
                    }
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(keywords, id: \.self) { keyword in
                                if let index = keywords.firstIndex(of: keyword) {
                                    KeywordBubble(keyword: keyword) {
                                        deleteKeyword(at: index)
                                    }
                                }
                            }
                        }
                    }
                } header: {
                    Text(LocalizedStringKey("keywords_section_label"))
                } footer: {
                    Text(LocalizedStringKey("keywords_footer"))
                }

//                Section {
//                    Button(LocalizedStringKey("submit_specifications_label")) {
//                        self.addSpecifications.toggle()
//                    }
//                    .frame(maxWidth: .infinity, alignment: .center)
//                } header: {
//                    Text(LocalizedStringKey("specifications_section_label"))
//                }

                // Legal and warning information section
                Section(header: Text(LocalizedStringKey("legal_and_warning_section_label"))) {
                    VStack(alignment: .leading) {
                        
                        Text(LocalizedStringKey("warranty_section_label"))
                            .font(.headline)
                        TextEditor(text: Binding(
                            get: { self.warranty ?? "" },
                            set: { self.warranty = self.limitText($0) }
                        ))
                        .frame(height: 100)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5), lineWidth: 0.5))

                        Text(LocalizedStringKey("enter_legal_info"))
                            .font(.headline)
                        TextEditor(text: Binding(
                            get: { self.legal ?? "" },
                            set: { self.legal = self.limitText($0) }
                        ))
                        .frame(height: 100)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5), lineWidth: 0.5))

                        Text(LocalizedStringKey("enter_warning_info"))
                            .font(.headline)
                        TextEditor(text: Binding(
                            get: { self.warning ?? "" },
                            set: { self.warning = self.limitText($0) }
                        ))
                        .frame(height: 100)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5), lineWidth: 0.5))
                    }
                }

                Section {
                    Button(oldMainImageBelongs ? LocalizedStringKey("update_label") : LocalizedStringKey("create_label")) {
                        validateAndSaveProduct()
                    }
                    .disabled(isUploading)
                    .frame(maxWidth: .infinity, alignment: .center)
                    if isUploading {
                        ProgressView(value: uploadProgress)
                            .progressViewStyle(LinearProgressViewStyle())
                            .padding()
                        Text(NSLocalizedString("uploading", comment: ""))
                    }
                } footer: {
                    Text(LocalizedStringKey("submit_footer"))
                }

            }
            .navigationTitle(name.isEmpty ? String(localized: "product_title") : name)
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: photosPickerItem) {
                Task {
                    if let photosPickerItem, let data = try? await photosPickerItem.loadTransferable(type: Data.self) {
                        if let image = UIImage(data: data) {
                            self.image = image
                            self.mainImageHasChanged = true
                        }
                    }
                }
            }
            .onAppear {
                if let oldMainImagePath {
                    downloadImage(for: oldMainImagePath)
                } else {
                    self.image = .init(systemName: "photo")
                }
            }
            .sheet(isPresented: $addSpecifications) {
                AddSpecificationsView(specifications: specifications) { newSpecifications in
                    self.specifications = newSpecifications
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(LocalizedStringKey("validation_error_title")),
                    message: Text(alertMessage),
                    dismissButton: .default(Text(LocalizedStringKey("ok_button")))
                )
            }
            .alert(isPresented: $showRequestAlert) {
                Alert(
                    title: Text("Product alert"),
                    message: Text(alertRequestMessage),
                    dismissButton: .default(Text("Accept"))
                )
            }
        }
    }
    
    init(product: Product, popToRoot: @escaping () -> Void) {
        self.product = product
        _name = State(wrappedValue: product.name)
        _label = State(wrappedValue: product.label ?? "")
        _owner = State(wrappedValue: product.owner ?? "")
        _year = State(wrappedValue: product.year ?? "2024")
        _model = State(wrappedValue: product.model)
        _description = State(wrappedValue: product.description)
        _group = State(wrappedValue: product.category.group)
        _domain = State(wrappedValue: product.category.domain)
        _subclass = State(wrappedValue: product.category.subclass)
        _stock = State(wrappedValue: product.stock)
        _origin = State(wrappedValue: product.origin)
        _oldMainImagePath = State(wrappedValue: product.image.path)
        _oldMainImageUrl = State(wrappedValue: product.image.url)
        _oldMainImageBelongs = State(wrappedValue: product.image.belongs)
        _overview = State(wrappedValue: product.overview)
        _keywords = State(wrappedValue: product.keywords ?? [])
        _codes = State(wrappedValue: product.codes ?? Codes(EAN: ""))
        _specifications = State(wrappedValue: product.specifications)
        _warranty = State(wrappedValue: product.warranty)
        _legal = State(wrappedValue: product.legal)
        _warning = State(wrappedValue: product.warning)
        _priceAmount = State(wrappedValue: String(product.price.amount))
        _priceCurrency = State(wrappedValue: product.price.currency)
        _offerIsActive = State(wrappedValue: product.price.offer.isActive)
        _offerDiscount = State(wrappedValue: product.price.offer.discount)
        if let creditCard = product.price.creditCard {
            _creditCardWithInterest = State(wrappedValue: creditCard.withInterest)
            _creditCardWithoutInterest = State(wrappedValue: creditCard.withoutInterest)
            _creditCardFreeMonths = State(wrappedValue: creditCard.freeMonths)
        }
        self.user = Auth.auth().currentUser?.uid ?? ""
        self.popToRoot = popToRoot
    }
    
    private func validateAndSaveProduct() {
        guard !name.isEmpty else {
            alertMessage = NSLocalizedString("error_empty_name", comment: "Product name cannot be empty.")
            showAlert = true
            return
        }
        
        guard !description.isEmpty else {
            alertMessage = NSLocalizedString("error_empty_description", comment: "Product description cannot be empty.")
            showAlert = true
            return
        }
        
        guard !group.isEmpty else {
            alertMessage = NSLocalizedString("error_empty_group", comment: "Please select a group.")
            showAlert = true
            return
        }
        
        guard !domain.isEmpty else {
            alertMessage = NSLocalizedString("error_empty_category", comment: "Please select a category.")
            showAlert = true
            return
        }
        
        guard !subclass.isEmpty else {
            alertMessage = NSLocalizedString("error_empty_subcategory", comment: "Please select a subcategory.")
            showAlert = true
            return
        }
        
        guard stock > 0 else {
            alertMessage = NSLocalizedString("error_invalid_stock", comment: "Stock must be at least 1.")
            showAlert = true
            return
        }
        
        guard let legal = legal, !legal.isEmpty else {
            alertMessage = NSLocalizedString("error_empty_legal", comment: "Legal information cannot be empty.")
            showAlert = true
            return
        }
        
        guard let warning = warning, !warning.isEmpty else {
            alertMessage = NSLocalizedString("error_empty_warning", comment: "Warning information cannot be empty.")
            showAlert = true
            return
        }
        
        guard let priceAmountValue = Double(priceAmount), !priceAmount.isEmpty else {
            alertMessage = NSLocalizedString("error_invalid_price", comment: "Price amount must be a valid number.")
            showAlert = true
            return
        }
        
        guard offerDiscount > 0 else {
            alertMessage = NSLocalizedString("error_invalid_discount", comment: "Offer discount must be a valid number.")
            showAlert = true
            return
        }
        
        guard creditCardWithInterest >= 0 else {
            alertMessage = NSLocalizedString("error_invalid_with_interest", comment: "Credit card with interest value must be a valid number.")
            showAlert = true
            return
        }
        
        guard creditCardWithoutInterest >= 0 else {
            alertMessage = NSLocalizedString("error_invalid_without_interest", comment: "Credit card without interest value must be a valid number.")
            showAlert = true
            return
        }
        
        guard creditCardFreeMonths >= 0 else {
            alertMessage = NSLocalizedString("error_invalid_free_months", comment: "Credit card free months value must be a valid number.")
            showAlert = true
            return
        }
        
        let price = Price(amount: priceAmountValue, currency: priceCurrency, offer: Offer(isActive: offerIsActive, discount: offerDiscount), creditCard: CreditCard(withoutInterest: creditCardWithoutInterest, withInterest: creditCardWithInterest, freeMonths: creditCardFreeMonths))
        let path = "fake/stores/images/\(Auth.auth().currentUser!.uid)/\(UUID().uuidString).jpg"
        
        if !mainImageHasChanged {
            if oldMainImageBelongs {
                let pro = toProduct(id: product.id, overview: overview, price: price)
                do {
                    try viewModel.putProduct(product: pro) { successMessage in
                        print("Name: \(pro.name)")
                        onSuccess(successMessage)
                        viewModel.removeAllProducts()
                    } onFailure: { errorMessage in
                        onFailure(errorMessage)
                    }
                } catch {
                    onFailure(error.localizedDescription)
                }
            } else {
                guard let compressedImageData = image?.compressImage() else {
                    print("Failed to compress image")
                    return
                }
                isUploading = true

                uploadImageToFirebaseWithProcessHandler(for: path, with: compressedImageData, progressHandler: { progress in
                    DispatchQueue.main.async { self.uploadProgress = progress }}) { imageInfo in
                        DispatchQueue.main.async {
                            self.isUploading = false
                            if let imageInfo = imageInfo {
                                let product = toProduct(id: product.id, info: imageInfo, price: price)
                                do {
                                    try viewModel.postProduct(product: product) { success in
                                        onSuccess(success)
                                    } onFailure: { failure in
                                        onFailure(failure)
                                    }
                                } catch {
                                    print("Error posting product: \(error)")
                                }
                            } else {
                                print("Failed to upload image")
                            }
                        }
                    }
            }
        } else {
            if let oldMainImagePath {
                if shouldDeletePath(path: oldMainImagePath) {
                    deleteImageFromFirebase(for: oldMainImagePath) {
                        
                        guard let compressedImageData = image?.compressImage() else {
                            print("Failed to compress image")
                            return
                        }
                        isUploading = true

                        uploadImageToFirebaseWithProcessHandler(for: path, with: compressedImageData, progressHandler: { progress in
                            DispatchQueue.main.async { self.uploadProgress = progress }}) { imageInfo in
                                DispatchQueue.main.async {
                                    self.isUploading = false
                                    if let imageInfo = imageInfo {
                                        if oldMainImageBelongs {
                                            let pro = toProduct(id: product.id, info: imageInfo, price: price)
                                            do {
                                                try viewModel.putProduct(product: pro) { success in
                                                    onSuccess(success)
                                                } onFailure: { failure in
                                                    onFailure(failure)
                                                }
                                            } catch {
                                                print("Error posting product: \(error)")
                                            }
                                        } else {
                                            let product = toProduct(id: product.id, info: imageInfo, price: price)
                                            do {
                                                try viewModel.postProduct(product: product){ success in
                                                    onSuccess(success)
                                                } onFailure: { failure in
                                                    onFailure(failure)
                                                }
                                            } catch {
                                                print("Error posting product: \(error)")
                                            }
                                        }
                                    } else {
                                        print("Failed to upload image")
                                    }
                                }
                            }
                    }
                } else {
                    print("Path should not be deleted")
                }
            } else {
                print("oldMainImagePath is nil")
            }
        }
    }
    
    private func toProduct(id: String, overview: [Information], price: Price) -> Product {
        return Product(id: id, name: name, label: label, owner: owner, year: year, model: model, description: description, category: Category(group: group, domain: domain, subclass: subclass), price: price, stock: stock, image: ImageX(path: oldMainImagePath, url: oldMainImageUrl, belongs: true), origin: origin, date: Date().currentTimeMillis(), overview: overview, keywords: keywords, codes: codes, specifications: specifications, warranty: warranty, legal: legal, warning: warning, storeId: user)
    }
    
    private func toProduct(id: String, info imageInfo: ImageInfo, price: Price) -> Product {
        return Product(id: id, name: name, label: label, owner: owner, year: year, model: model, description: description, category: Category(group: group, domain: domain, subclass: subclass), price: price, stock: stock, image: ImageX(path: imageInfo.path, url: imageInfo.url, belongs: true), origin: origin, date: Date().currentTimeMillis(), overview: overview, keywords: keywords, codes: codes, specifications: specifications, warranty: warranty, legal: legal, warning: warning, storeId: user)
    }
    
    /**
     This function downloads an image from Firebase Storage using the provided path.
     - Parameter path: The path of the image in Firebase Storage.
     */
    private func downloadImage(for path: String) {
        let reference = Storage.storage().reference(withPath: path)
        reference.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error {
                print(error.localizedDescription)
                return
            }
            guard let data = data else { return }
            self.image = UIImage(data: data)
        }
    }
    
    private func limitText(_ text: String) -> String {
        let lines = text.components(separatedBy: .newlines)
        if lines.count > 4 {
            return lines.prefix(4).joined(separator: "\n")
        }
        
        let words = text.split(separator: " ")
        if words.count > 100 {
            return words.prefix(100).joined(separator: " ")
        }
        
        return text
    }
    
    private func addKeyword() {
        if !word.isEmpty {
//            if keywords == nil {
//                keywords = []
//            }
            keywords.insert(word, at: 0)
            word = ""
        }
    }
    
    private func deleteKeyword(at index: Int) {
        keywords.remove(at: index)
//        if keywords?.isEmpty == true {
//            keywords = nil
//        }
    }
    
    private func onSuccess(_ success: String) {
        alertMessage = success
        showAlert = true
        dismiss()
        popToRoot()
    }
    
    private func onFailure(_ failure: String) {
        alertMessage = failure
        showAlert = true
        dismiss()
        popToRoot()
    }
}
