//
//  TransactionForm.swift
//  MoneyTracker
//
//  Created by Nicolas Monzon on 30/7/2023.
//

import SwiftUI

struct TransactionForm: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var name: String = ""
    @State private var amount: String = ""
    @State private var date: Date = Date()
    @State private var photoData: Data?
    @State private var shouldPresentPhotoPicker: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Information")) {
                    TextField("Name", text: $name)
                    TextField("Amount", text: $amount)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    NavigationLink {
                        NavigationView {
                            Text("Categories Page")
                        }
                        .navigationTitle(Text("TITLE"))
                    } label: {
                        Text("Many to many")
                    }

                }
                
                Section(header: Text("PHOTO/RECEIPT")) {
                    Button {
                        shouldPresentPhotoPicker.toggle()
                    } label: {
                        Text("Select Photo")
                    }
                    .fullScreenCover(isPresented: $shouldPresentPhotoPicker) {
                        PhotoPickerView(photoData: $photoData)
                    }
                    if let data = photoData, let image = UIImage.init(data: data) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                    }

                }
            }
            .navigationBarItems(leading: cancelButton, trailing: saveButton)
            .navigationTitle("Add Transaction")
        }
    }
    
    struct PhotoPickerView: UIViewControllerRepresentable {
        
        @Binding var photoData: Data?
        
        func makeCoordinator() -> Coordinator {
            return Coordinator(parent: self)
        }
        
        class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
            
            private let parent: PhotoPickerView
            
            init(parent: PhotoPickerView) {
                self.parent = parent
            }
            
            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                let image = info[.originalImage] as? UIImage
                let imageData = image?.jpegData(compressionQuality: 1)
                self.parent.photoData = imageData
                picker.dismiss(animated: true)
            }
            
            func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
                picker.dismiss(animated: true)
            }
        }
        
        func makeUIViewController(context: Context) -> some UIViewController {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = context.coordinator
            return imagePicker
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
        
    }
    
    private var cancelButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Text("Cancel")
        }
    }
    
    private var saveButton: some View {
        Button {
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let transaction = CardTransaction(context: context)
            transaction.name = self.name
            transaction.amount = Float(self.amount) ?? 0
            transaction.timestamp = self.date
            transaction.photoData = self.photoData
            
            do {
                try context.save()
                presentationMode.wrappedValue.dismiss()
            } catch {
                print("Failed to save transaction context \(error)")
            }
        } label: {
            Text("Save")
        }
    }
}

struct TransactionForm_Previews: PreviewProvider {
    static var previews: some View {
        TransactionForm()
    }
}
