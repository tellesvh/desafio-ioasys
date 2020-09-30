//
//  Login.swift
//  Desafio.Ioasys
//
//  Created by Victor Hugo Telles on 29/09/20.
//

import SwiftUI

struct Login: View {
    @ObservedObject var keyboardResponder = KeyboardResponder()
    @State var email: String = ""
    
    var body: some View {
        Background {
            NavigationView {
                VStack {
                    ZStack {
                        Image("background_login")
                            .resizable()
                            .scaledToFit()
                        VStack(spacing: 14) {
                            Image("logo_ioasys_symbol")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .offset(y: keyboardResponder.currentHeight*0.18)
                            if (keyboardResponder.currentHeight == 0) {
                                Text("Seja bem vindo ao Empresas!")
                            }
                        }
                        .offset(y: 8)
                    }
                    .offset(y: keyboardResponder.currentHeight*0.1)
                    Spacer()
                    VStack {
                        TextField("Enter your first name", text: $email).textFieldStyle(RoundedBorderTextFieldStyle())
                        TextField("Enter your first name", text: $email).textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    Spacer()
                    Spacer()
                }
                .navigationBarHidden(true)
                .edgesIgnoringSafeArea([.top])
            }
        }.onTapGesture {
            self.endEditing()
        }
    }
    
    private func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}






struct Background<Content: View>: View {
    private var content: Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }

    var body: some View {
        Color.white
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .overlay(content)
    }
}
