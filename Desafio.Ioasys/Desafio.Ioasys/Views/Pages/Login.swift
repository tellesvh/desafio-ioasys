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
    @State var password: String = ""
    
    var body: some View {
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
                            .offset(y: keyboardResponder.currentHeight*0.17)
                        if (keyboardResponder.currentHeight == 0) {
                            Text("Seja bem vindo ao Empresas!")
                                .foregroundColor(.white)
                                .font(Font.custom("Rubik", size: 20))
                                .fontWeight(.regular)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .offset(y: 8)
                }
                .offset(y: -keyboardResponder.currentHeight*0.3)
                if (keyboardResponder.currentHeight == 0) {
                    Spacer()
                }
                VStack(spacing: 24) {
                    TextFieldLabel(label: "Email", text: $email, placeholder: "Digite seu email.", keyboardType: .emailAddress, isSecure: false)
                    TextFieldLabel(label: "Senha", text: $password, placeholder: "Digite sua senha.", keyboardType: .default, isSecure: true)
                    Button(action: {
                        print("Entrar.")
                    }) {
                        HStack {
                            Text("ENTRAR")
                                .font(Font.custom("Rubik", size: 16))
                                .fontWeight(.medium)
                        }
                        .padding(12)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(Color("Pink 1"))
                        .cornerRadius(6)
                    }
                }
                .offset(y: -keyboardResponder.currentHeight*0.2)
                .padding([.leading, .trailing])
                if (keyboardResponder.currentHeight == 0) {
                    Spacer()
                    Spacer()
                }
            }
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea([.top])
        }
    }
    
    private func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct TextFieldLabel: View {
    @State var label: String
    @Binding var text: String
    @State var placeholder: String
    @State var keyboardType: UIKeyboardType
    @State var isSecure: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .foregroundColor(.black)
                .font(Font.custom("Rubik", size: 12))
                .fontWeight(.regular)
            if (!isSecure) {
                TextField(placeholder, text: $text)
                    .textFieldStyle(LoginTextFieldStyle(keyboardType: $keyboardType))
            } else {
                SecureField(placeholder, text: $text)
                    .textFieldStyle(LoginTextFieldStyle(keyboardType: $keyboardType))
            }
        }
    }
}

struct LoginTextFieldStyle: TextFieldStyle {
    @Binding var keyboardType: UIKeyboardType

    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(16)
            .keyboardType(keyboardType)
            .font(Font.custom("Rubik", size: 16))
            .background(RoundedRectangle(cornerRadius: 6).foregroundColor(Color("Gray 1")))
            .foregroundColor(.black)
    }
    
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
