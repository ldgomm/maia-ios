//
//  AddEditWarranty.swift
//  Sales
//
//  Created by José Ruiz on 30/5/24.
//

import SwiftUI

struct AddEditWarranty: View {
    @Environment(\.dismiss) var dismiss

    @State private var hasWarranty: Bool = false
    @State private var details: [String] = []
    @State private var months: Int = 0
    @State private var detailInput: String = ""
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var warranty: Warranty?
    var popToAddEditProductView: (Warranty) -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(LocalizedStringKey("warranty_status_section"))) {
                    Toggle(isOn: $hasWarranty) {
                        Text(LocalizedStringKey("has_warranty_label"))
                    }
                }
                
                if hasWarranty {
                    Section(header: Text(LocalizedStringKey("warranty_details_section")), footer: validationMessage(for: "details")) {
                        HStack {
                            TextField(LocalizedStringKey("enter_detail_placeholder"), text: $detailInput)
                            Button {
                                if !detailInput.isEmpty {
                                    details.append(detailInput)
                                    detailInput = ""
                                }
                            } label: {
                                Image(systemName: "plus")
                            }
                        }
                        List {
                            ForEach(details, id: \.self) { detail in
                                Text(detail)
                            }
                            .onDelete { indexSet in
                                details.remove(atOffsets: indexSet)
                            }
                        }
                    }
                    
                    Section(header: Text(LocalizedStringKey("warranty_duration_section")), footer: validationMessage(for: "months")) {
                        Stepper(value: $months, in: 0...120) {
                            Text("\(months) \(LocalizedStringKey("months_label"))")
                        }
                    }
                }
                
                Button(warranty != nil ? LocalizedStringKey("update_warranty_button") : LocalizedStringKey("add_warranty_button")) {
                    validateAndSaveWarranty()
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .navigationBarTitle(LocalizedStringKey("warranty_navigation_title"), displayMode: .inline)
            .alert(isPresented: $showAlert) {
                Alert(title: Text(LocalizedStringKey("validation_error_title")), message: Text(alertMessage), dismissButton: .default(Text(LocalizedStringKey("ok_button"))))
            }
        }
    }
    
    init(warranty: Warranty? = nil, popToAddEditProductView: @escaping (Warranty) -> Void) {
        if let warranty {
            self.warranty = warranty
            _hasWarranty = State(wrappedValue: warranty.hasWarranty)
            _details = State(wrappedValue: warranty.details)
            _months = State(wrappedValue: warranty.months)
        }
        self.popToAddEditProductView = popToAddEditProductView
    }
    
    private func validateAndSaveWarranty() {
        // Validation logic
        guard !hasWarranty || validateFields() else { return }

        let warranty = Warranty(hasWarranty: hasWarranty, details: hasWarranty ? details : [], months: hasWarranty ? months : 0)
        popToAddEditProductView(warranty)
        dismiss()
    }

    private func validateFields() -> Bool {
        if details.isEmpty {
            alertMessage = NSLocalizedString("error_empty_warranty_detail", comment: "Please add at least one warranty detail.")
            showAlert = true
            return false
        }

        if months == 0 {
            alertMessage = NSLocalizedString("error_zero_months", comment: "Warranty duration must be more than 0 months.")
            showAlert = true
            return false
        }

        return true
    }

    private func validationMessage(for field: String) -> some View {
        let message: String
        switch field {
        case "details":
            message = details.isEmpty ? NSLocalizedString("error_empty_warranty_detail", comment: "Please add at least one warranty detail.") : ""
        case "months":
            message = months == 0 ? NSLocalizedString("error_zero_months", comment: "Warranty duration must be more than 0 months.") : ""
        default:
            message = ""
        }
        
        return Text(message)
            .foregroundColor(.red)
            .font(.footnote)
    }
}
