//
//  MainView.swift
//  MoneyTracker
//
//  Created by Nicolas Monzon on 20/08/2021.
//

import SwiftUI

struct MainView: View {
    
    @State private var shouldPresentAddCardForm = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                TabView {
                    ForEach(0..<5) { num in
                        CreditCardView()
                            .padding(.bottom, 40)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .indexViewStyle(PageIndexViewStyle.init(backgroundDisplayMode: .always))
                .frame(height: 280)
                Spacer()
                    .fullScreenCover(isPresented: $shouldPresentAddCardForm) {
                    AddCardForm()
                }
            }
            .navigationTitle("Credit Cards")
            .navigationBarItems(trailing: addCardButton)
        }
    }
    
    struct CreditCardView: View {
        var body: some View {
            VStack(alignment: .leading,spacing: 16, content: {
                Text("Apple Blue Visa Card")
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
                Text("1234 1234 1234 1234")
                Text("Credit Limit: $50,000")
            })
            .padding()
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.blue]), startPoint: .center, endPoint: .bottom)
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
        MainView()
    }
}
