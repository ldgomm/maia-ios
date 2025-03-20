//
//  AddInformationView.swift
//  Sales
//
//  Created by José Ruiz on 8/5/24.
//

//import FirebaseStorage
//import PhotosUI
//import SwiftUI
//
//struct AddEditInformationView: View {
//    @Environment(\.dismiss) var dismiss
//
//    @State private var id: String = UUID().uuidString
//    @State private var title: String = ""
//    @State private var subtitle: String = ""
//    @State private var description: String = ""
//    @State private var place: Int = 0
//    
//    //Photo
//    @State private var image: UIImage? = .init(systemName: "photo")
//    @State private var photosPickerItem: PhotosPickerItem?
//    
//    var popToAddEditProductView: (InformationResult) -> Void
//
//    var body: some View {
//        NavigationView {
//            Form {
//                Section {
//                    PhotosPicker(selection: $photosPickerItem, matching: .images) {
//                        Image(uiImage: image ?? UIImage(systemName: "photo")!)
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .clipShape(RoundedRectangle(cornerRadius: 11))
//                            .frame(maxWidth: .infinity, maxHeight: 300)
//                            .padding(.horizontal)
//                    }
//                }
//                Section {
//                    TextField("Title", text: $title, prompt: Text("Title"))
//                    TextField("Subitle", text: $subtitle, prompt: Text("Subtitle"))
//                    TextField("Description", text: $description, prompt: Text("Description"))
//                }
//                Section {
//                    Button {
//                        let result = InformationResult(id: id, title: title, subtitle: subtitle, description: description, image: image, path: "", place: place, isCreated: true, isDeleted: false)
//                        popToAddEditProductView(result)
//                        dismiss()
//                    } label: {
//                        Image(systemName: "plus")
//                    }.frame(maxWidth: .infinity, alignment: .center)
//                }
//            }
//            .navigationTitle("Add information")
//            .navigationBarTitleDisplayMode(.inline)
//        }
//        .onChange(of: photosPickerItem) {
//            Task {
//                if let photosPickerItem, let data = try? await photosPickerItem.loadTransferable(type: Data.self) {
//                    if let image = UIImage(data: data) {
//                        self.image = image
//                    }
//                }
//            }
//        }
//    }
//    
//    init(popToAddEditProductView: @escaping (InformationResult) -> Void) {
//        self.popToAddEditProductView = popToAddEditProductView
//    }
//}
