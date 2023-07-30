//
//  SwiftUIView.swift
//  MoneyTracker
//
//  Created by Nicolas Monzon on 28/7/2023.
//

import SwiftUI

struct AddCardForm: View {
    
    let card: Card?
    
    init(card: Card? = nil) {
        self.card = card
        
        _name = State(initialValue: card?.name ?? "")
        _cardNumber = State(initialValue: card?.number ?? "")
        if let limit = card?.limit {
            _creditLimit = State(initialValue: String(limit))
        }
        _cardType = State(initialValue: card?.type ?? "")
        
        _month = State(initialValue: "\(card?.expMonth ?? Int16(1))")
        _year = State(initialValue: Int(card?.expYear ?? Int16(currentYear)))
        
        if let data = card?.color, let uiColor = UIColor.color(data: data) {
            let c = Color(uiColor)
            _color = State(initialValue: c)
        }
    }
    
    @Environment(\.presentationMode) var presentatationMode
    @State private var name: String = ""
    @State private var cardNumber: String = ""
    @State private var creditLimit: String = ""
    
    @State private var cardType: String = "Visa"
    @State private var month: String = "1"
    @State private var year = Calendar.current.component(.year, from: Date())
    @State private var color = Color.blue
    let currentYear = Calendar.current.component(.year, from: Date())
    
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
            .navigationTitle(card != nil ? card?.name ?? "" : "Add Credit Card")
            .navigationBarItems(leading: cancelButton, trailing: saveButton)
        }
    }
    
    private var cancelButton: some View {
        Button("Cancel", action: {
            presentatationMode.wrappedValue.dismiss()
        })
    }
    
    private var saveButton: some View {
        Button("Save", action: {
            let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

            let card = card != nil ? self.card! : Card(context: viewContext)
            card.name = self.name
            card.number = self.cardNumber
            card.limit = Int32(self.creditLimit) ?? 0
            card.expMonth = Int16(self.month) ?? 0
            card.expYear = Int16(self.year)
            card.timestamp = Date() //le da el orden al hacer save
            card.color = UIColor(self.color).encode()
            card.type = cardType
            
            do {
                try viewContext.save()
                presentatationMode.wrappedValue.dismiss()
            } catch {
                print("Failed to persist new card: \(error)")
            }
            
        })
    }
}

extension UIColor {
    
    class func color(data: Data) -> UIColor? {
        return try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UIColor
    }
    
    func encode() -> Data? {
        return try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
    }
}

struct AddCardForm_Previews: PreviewProvider {
    static var previews: some View {
//        AddCardForm()
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        MainView()
            .environment(\.managedObjectContext, context)
    }
}
