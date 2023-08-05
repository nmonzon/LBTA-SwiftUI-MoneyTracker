//
//  TransactionCardView.swift
//  MoneyTracker
//
//  Created by Nicolas Monzon on 31/7/2023.
//

import SwiftUI

struct TransactionListView: View {
    
    let card: Card
    
    init(card: Card) {
        self.card = card
        fetchRequest = FetchRequest<CardTransaction>(entity: CardTransaction.entity(), sortDescriptors: [.init(key: "timestamp", ascending: false)], predicate: .init(format: "card == %@", self.card))
        
    }
    @State private var shouldPresentTransactionForm: Bool = false
     
    @Environment(\.managedObjectContext) private var viewContext
    
    var fetchRequest: FetchRequest<CardTransaction>
//    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \CardTransaction.timestamp, ascending: false)],animation: .default)
//    private var transactions: FetchedResults<CardTransaction>
    
    var body: some View {
        VStack {
            Text("Get started by adding your first transaction!")
            Button {
                shouldPresentTransactionForm.toggle()
            } label: {
                Text("+ Transaction")
                    .padding(EdgeInsets(top: 10, leading: 14, bottom: 10, trailing: 14))
                    .font(.headline)
                    .background(Color(.label))
                    .foregroundColor(Color(.systemBackground))
                    .cornerRadius(5)
            }
            .fullScreenCover(isPresented: $shouldPresentTransactionForm) {
                AddTransactionForm(card: card)
            }
            
            ForEach(fetchRequest.wrappedValue) { transaction in
                
                CardTransactionView(transaction: transaction)
            }
        }
    }
}

struct CardTransactionView: View {
    
    let transaction: CardTransaction
    @State private var shouldPresentDeleteTransaction: Bool = false
    
    var body: some View {
        VStack {
            HStack() {
                VStack(alignment: .leading) {
                    Text(transaction.name ?? "")
                            .font(.headline)
                    if let date = transaction.timestamp {
                        Text(dateFormatter.string(from: date))
                    }
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Button {
                        shouldPresentDeleteTransaction.toggle()
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.black)
                    }
                    .padding(EdgeInsets(top: 6, leading: 8, bottom: 4, trailing: 0))
                    .actionSheet(isPresented: $shouldPresentDeleteTransaction) {
                        .init(title: Text(transaction.name ?? ""), buttons: [
                            .destructive(Text("Delete"), action: {
                                handleDelete()
                            }),
                            .cancel(Text("Cancel"))
                        ])
                    }
                    Text(String(format: "$%.2f", transaction.amount))
                }
            }
            if let photoData = transaction.photoData, let uiImage = UIImage(data: photoData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            }
        }
        .foregroundColor(Color(.label))
        .padding()
        .background(Color.white)
        .cornerRadius(5)
        .shadow(radius: 5)
        .padding()
        
        
    }
    
    private func handleDelete() {
        withAnimation {
            do {
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                context.delete(transaction)
                try context.save()
            } catch {
                print("Failed to delete transaction", error)
            }
        }
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
}

struct TransactionCardView_Previews: PreviewProvider {
    static let firstCard: Card? = {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = Card.fetchRequest()
        request.sortDescriptors = [.init(key: "timestamp", ascending: false)]
        return try? context.fetch(request).first
    }()
    
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        ScrollView {
            if let card = firstCard {
                TransactionListView(card: card)
            }
        }
        .environment(\.managedObjectContext, context)
    }
}
