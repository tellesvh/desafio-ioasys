//
//  Login.swift
//  Desafio.Ioasys
//
//  Created by Victor Hugo Telles on 29/09/20.
//

import SwiftUI

struct Login: View {
    @ObservedObject var loginController = LoginController()
    @ObservedObject var keyboardResponder = KeyboardResponder()
    @State var email: String = ""
    @State var password: String = ""
    @State var error: String = ""
    @State var loading: Bool = false
    
    var body: some View {
        NavigationView {
            ProgressViewOverlay(isLoading: $loading) {
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
                    VStack(alignment: .trailing, spacing: 24) {
                        TextFieldLabel(label: "Email", text: $email, placeholder: "Digite seu email.", keyboardType: .emailAddress, autocapitalization: .none, isSecure: false, error: $error)
                        TextFieldLabel(label: "Senha", text: $password, placeholder: "Digite sua senha.", keyboardType: .default, autocapitalization: .none, isSecure: true, error: $error)
                        if (error.count > 0) {
                            Text(error)
                                .foregroundColor(Color("Error"))
                                .font(Font.custom("Rubik", size: 12))
                                .fontWeight(.regular)
                        }
                        Button(action: {
                            logUserIn()
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
                .preferredColorScheme(.light)
            }
        }
    }
    
    func logUserIn() {
        loading = true
        // TODO Fazer validação de email
        loginController.logUserIn(email: email, password: password) {
            (result: Result<LoginResponse, Error>) in
            switch result{
                case .success(let loginResponse):
                    print(loginResponse)
                    // TODO Enviar usuário para próxima página
                case .failure(let error):
                    print(error)
                    // error = error.count > 0 ? "" :  "erro"
            }
            loading = false
        }
    }
    
}

struct TextFieldLabel: View {
    @State var label: String
    @Binding var text: String
    @State var placeholder: String
    @State var keyboardType: UIKeyboardType
    @State var autocapitalization: UITextAutocapitalizationType
    @State var isSecure: Bool
    @Binding var error: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .foregroundColor(.black)
                .font(Font.custom("Rubik", size: 12))
                .fontWeight(.regular)
            if (!isSecure) {
                TextField(placeholder, text: $text)
                    .textFieldStyle(LoginTextFieldStyle(keyboardType: $keyboardType, autocapitalization: $autocapitalization, error: .constant(error.count > 0)))
            } else {
                SecureField(placeholder, text: $text)
                    .textFieldStyle(LoginTextFieldStyle(keyboardType: $keyboardType, autocapitalization: $autocapitalization, error: .constant(error.count > 0)))
            }
        }
    }
}

struct LoginTextFieldStyle: TextFieldStyle {
    @Binding var keyboardType: UIKeyboardType
    @Binding var autocapitalization: UITextAutocapitalizationType
    @Binding var error: Bool

    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(16)
            .keyboardType(keyboardType)
            .font(Font.custom("Rubik", size: 16))
            .background(RoundedRectangle(cornerRadius: 6).foregroundColor(Color("Gray 1")))
            .foregroundColor(.black)
            .autocapitalization(autocapitalization)
            .if(error) { $0.overlay(RoundedRectangle(cornerRadius: 10).stroke(Color("Error"), lineWidth: 1)) }
    }
    
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
