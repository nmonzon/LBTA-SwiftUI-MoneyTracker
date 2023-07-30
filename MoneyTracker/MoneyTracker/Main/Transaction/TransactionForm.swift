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

                    } label: {
                        Text("Select Photo")
                    }

                }
            }
            .navigationBarItems(leading: cancelButton, trailing: saveButton)
            .navigationTitle("Add Transaction")
        }
    }
    
    var cancelButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Text("Cancel")
        }
    }
    
    var saveButton: some View {
        Button {
            
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
