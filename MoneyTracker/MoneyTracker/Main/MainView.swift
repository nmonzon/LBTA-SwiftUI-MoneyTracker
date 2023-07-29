//
//  MainView.swift
//  MoneyTracker
//
//  Created by Nicolas Monzon on 20/08/2021.
//

import SwiftUI

struct MainView: View {
    
    @State private var shouldPresentAddCardForm = false
    
    //amount to credit card variable
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Card.timestamp, ascending: true)],animation: .default)
    private var cards: FetchedResults<Card>
    
    var body: some View {
        NavigationView {
            ScrollView {
                if !cards.isEmpty {
                    TabView {
                        ForEach(cards) { card in
                            CreditCardView(card: card)
                                .padding(.bottom, 40)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                    .indexViewStyle(PageIndexViewStyle.init(backgroundDisplayMode: .always))
                    .frame(height: 280)
                }
        
                Spacer()
                    .fullScreenCover(isPresented: $shouldPresentAddCardForm) {
                    AddCardForm()
                }
            }
            .navigationTitle("Credit Cards")
            .navigationBarItems(leading: HStack {
                addItemButton
                deleteAllButton
            }, trailing: addCardButton)
        }
    }
    
    var addItemButton: some View {
        Button {
            withAnimation {
                let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

                let card = Card(context: viewContext)
                card.timestamp = Date()
                
                do {
                    try viewContext.save()
                } catch {
                }
            }
        } label: {
            Text("Add Item")
        }

    }
    
    
    struct CreditCardView: View {
        
        let card: Card
        
        var body: some View {
            VStack(alignment: .leading,spacing: 16, content: {
                Text(card.name ?? "")
                    .font(Font.system(size: 24, weight: .semibold, design: Font.Design.default))
                HStack(){
                    Image("Visa")
                        .resizable()
                        .scaledToFit()
                        .frame(height:44)
                        .clipped()
                    Spacer()
                    Text("Balance: $5,000")
                        .font(Font.system(size: 16, weight: .semibold, design: Font.Design.default))
                }
                Text(card.number ?? "")
                Text("Credit Limit: $\(card.limit)")
            })
            .padding()
            .background(
                VStack {
                    
                    if let colorData = card.color,
                       let uiColor = UIColor.color(data: colorData) {
                        LinearGradient(gradient: Gradient(colors: [
                            Color(uiColor).opacity(0.6),
                            Color(uiColor)
                      ]), startPoint: .center, endPoint: .bottom)
                    } else {
                        Color.purple
                    }
                  
                }
            )
            .overlay(RoundedRectangle(cornerRadius: 8)
                .stroke(Color.black.opacity(0.5), lineWidth: 1)
            )
            .foregroundColor(.white)
            .cornerRadius(8)
            .shadow(radius: 5)
            .padding(.horizontal)
            .padding(.top, 8)
        }
    }
    
    var deleteAllButton: some View {
        Button {
            cards.forEach { card in
                viewContext.delete(card)
            }
            do {
                try viewContext.save()
            } catch {
                
            }
        } label: {
            Text("Delete All")
        }

    }
    
    var addCardButton: some View {
        Button(action: {
            shouldPresentAddCardForm.toggle()
        }, label: {
            Text("+ Card")
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .bold))
                .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                .background(Color.black)
                .cornerRadius(5)
        })
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        MainView()
            .environment(\.managedObjectContext, context)
    }
}
