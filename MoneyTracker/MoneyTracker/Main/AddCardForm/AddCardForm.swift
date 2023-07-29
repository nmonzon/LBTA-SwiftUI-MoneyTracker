//
//  SwiftUIView.swift
//  MoneyTracker
//
//  Created by Nicolas Monzon on 28/7/2023.
//

import SwiftUI

struct AddCardForm: View {
    
    @Environment(\.presentationMode) var presentatationMode
    @State private var name: String = ""
    @State private var cardNumber: String = ""
    @State private var creditLimit: String = ""
    
    @State private var cardType: String = "Visa"
    @State private var month: String = "1"
    @State private var year = Calendar.current.component(.year, from: Date())
    @State private var color = Color.blue
    
    var body: some View {
        NavigationView {
            Form {
                
                Section(header: Text("CARD INFO")) {
                    TextField("Name", text: $name)
                    TextField("Credit Card Number", text: $cardNumber)
                        .keyboardType(.numberPad)
                    TextField("Credit Limit", text: $creditLimit)
                    Picker("Type", selection: $cardType) {
                        ForEach(["Visa", "MasterCard","Discover","CityBank"], id: \.self) { cardType in
                            Text(String(cardType)).tag(String(cardType))
                        }
                    }
                }
                
                Section(header: Text("EXPIRATION")) {
                    Picker("Month", selection: $month) {
                        ForEach(1..<13, id: \.self) { month in
                            Text(String(month)).tag(String(month))
                        }
                    }
                    
                    Picker("Year", selection: $year) {
                        ForEach(year..<year+20, id: \.self) { year in
                            Text(String(year)).tag(String(year))
                        }
                    }
                }
                
                Section(header: Text("COLOR")) {
                    ColorPicker("Color", selection: $color)
                }
            }
            .navigationTitle("Add Credit Card")
            .navigationBarItems(leading: Button("Cancel", action: {
                presentatationMode.wrappedValue.dismiss()
            }))
        }
    }
}

struct AddCardForm_Previews: PreviewProvider {
    static var previews: some View {
        AddCardForm()
    }
}
