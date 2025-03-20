//
//  SpecificationView.swift
//  Sales
//
//  Created by José Ruiz on 30/5/24.
//

import SwiftUI

struct AddSpecificationsView: View {
    @Environment(\.dismiss) var dismiss

    @State private var colours: [String] = []
    @State private var finished: String = ""
    @State private var inBox: [String] = []
    
    @State private var width: Double?
    @State private var height: Double?
    @State private var depth: Double?
    @State private var weight: Double?
    @State private var sizeUnit: String = "cm"
    @State private var weightUnit: String = "kg"
    
    @State private var newColour: String = ""
    @State private var newInBoxItem: String = ""
    
    let sizeUnits = ["mm", "cm", "m", "in", "ft", "yd"]
    let weightUnits = ["mg", "g", "kg", "lb", "oz", "t"]

    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    var specifications: Specifications?
    var popToAddEditProductView: (Specifications) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(LocalizedStringKey("colours_section_label"))) {
                    ForEach(colours, id: \.self) { colour in
                        Text(colour)
                    }
                    HStack {
                        TextField(LocalizedStringKey("add_colour_placeholder"), text: $newColour)
                        Button(LocalizedStringKey("add_button_label")) {
                            if !newColour.isEmpty {
                                colours.append(newColour)
                                newColour = ""
                            }
                        }
                        .disabled(newColour.isEmpty)
                    }
                }
                
                Section(header: Text(LocalizedStringKey("finished_section_label"))) {
                    TextField(LocalizedStringKey("finished_placeholder"), text: $finished)
                }
                
                Section(header: Text(LocalizedStringKey("in_box_items_section_label"))) {
                    ForEach(inBox, id: \.self) { item in
                        Text(item)
                    }
                    HStack {
                        TextField(LocalizedStringKey("add_item_placeholder"), text: $newInBoxItem)
                        Button(LocalizedStringKey("add_button_label")) {
                            if !newInBoxItem.isEmpty {
                                inBox.append(newInBoxItem)
                                newInBoxItem = ""
                            }
                        }
                        .disabled(newInBoxItem.isEmpty)
                    }
                }
                
                Section {
                    TextField(LocalizedStringKey("width_placeholder"), value: $width, formatter: numberFormatter)
                        .keyboardType(.decimalPad)
                    TextField(LocalizedStringKey("height_placeholder"), value: $height, formatter: numberFormatter)
                        .keyboardType(.decimalPad)
                    TextField(LocalizedStringKey("depth_placeholder"), value: $depth, formatter: numberFormatter)
                        .keyboardType(.decimalPad)
                    Picker(LocalizedStringKey("unit_label"), selection: $sizeUnit) {
                        ForEach(sizeUnits, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text(LocalizedStringKey("size_section_label"))
                }
                
                Section {
                    TextField(LocalizedStringKey("weight_placeholder"), value: $weight, formatter: numberFormatter)
                        .keyboardType(.decimalPad)
                    Picker(LocalizedStringKey("unit_label"), selection: $weightUnit) {
                        ForEach(weightUnits, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text(LocalizedStringKey("weight_section_label"))
                }
                
                Button(action: saveSpecification) {
                    Text(specifications != nil ? LocalizedStringKey("update_specifications_button") : LocalizedStringKey("add_specifications_button"))
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .navigationTitle(LocalizedStringKey("specifications_navigation_title"))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    init(specifications: Specifications? = nil, popToAddEditProductView: @escaping (Specifications) -> Void) {
        if let specifications {
            self.specifications = specifications
            _colours = State(wrappedValue: specifications.colours)
            _colours = State(wrappedValue: specifications.colours)
            _finished = State(wrappedValue: specifications.finished ?? "")
            _inBox = State(wrappedValue: specifications.inBox ?? [])
            if let size = specifications.size {
                _width = State(wrappedValue: size.width)
                _height = State(wrappedValue: size.height)
                _depth = State(wrappedValue: size.depth)
                _sizeUnit = State(wrappedValue: size.unit)
                
            }
            if let weight = specifications.weight {
                _weight = State(wrappedValue: weight.weight)
                _weightUnit = State(wrappedValue: weight.unit)
            }
        }
        self.popToAddEditProductView = popToAddEditProductView
    }
    
    private func saveSpecification() {
        guard let width = width, let height = height, let depth = depth, let weightValue = weight else {
            return
        }
        let size = Size(width: width, height: height, depth: depth, unit: sizeUnit)
        let weight = Weight(weight: weightValue, unit: weightUnit)
        let specifications = Specifications(colours: colours, finished: finished, inBox: inBox, size: size, weight: weight)
        popToAddEditProductView(specifications)
        dismiss()
    }
}
