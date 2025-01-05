//
//  FilterView.swift
//  Maia
//
//  Created by José Ruiz on 29/7/24.
//

import SwiftUI

struct FilterView: View {
    @Binding var selectedMi: Mi?
    @Binding var selectedNi: Ni?
    @Binding var selectedXi: Xi?
    var categories: Categories
    var products: [Product]

    var nonEmptyCategories: Categories {
        var result: Categories = [:]
        for (mi, niDict) in categories {
            var nonEmptyNiDict: [Ni: [Xi]] = [:]
            for (ni, xiList) in niDict {
                let nonEmptyXiList = xiList.filter { xi in
                    products.contains { $0.category.group == mi.name && $0.category.domain == ni.name && $0.category.subclass == xi.name }
                }
                if !nonEmptyXiList.isEmpty {
                    nonEmptyNiDict[ni] = nonEmptyXiList
                }
            }
            if !nonEmptyNiDict.isEmpty {
                result[mi] = nonEmptyNiDict
            }
        }
        return result
    }

    var body: some View {
        VStack {
            Picker(LocalizedStringKey("group_picker_label"), selection: $selectedMi) {
                Text(LocalizedStringKey("all_picker_option")).tag(nil as Mi?)
                ForEach(nonEmptyCategories.keys.sorted(by: { $0.name < $1.name }), id: \.self) { mi in
                    Text(mi.name).tag(mi as Mi?)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            if let selectedMi = selectedMi {
                Picker(LocalizedStringKey("category_picker_label"), selection: $selectedNi) {
                    Text(LocalizedStringKey("all_picker_option")).tag(nil as Ni?)
                    ForEach(nonEmptyCategories[selectedMi]?.keys.sorted(by: { $0.name < $1.name }) ?? [], id: \.self) { ni in
                        Text(ni.name).tag(ni as Ni?)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            if let selectedMi = selectedMi, let selectedNi = selectedNi {
                Picker(LocalizedStringKey("subcategory_picker_label"), selection: $selectedXi) {
                    Text(LocalizedStringKey("all_picker_option")).tag(nil as Xi?)
                    ForEach(nonEmptyCategories[selectedMi]?[selectedNi]?.sorted(by: { $0.name < $1.name }) ?? [], id: \.self) { xi in
                        Text(xi.name).tag(xi as Xi?)
                    }
                }
                .pickerStyle(.segmented)
            }
        }
        .padding(.horizontal)
    }

}

