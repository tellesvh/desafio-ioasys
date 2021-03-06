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
    @State var errors: [String] = []
    @State var loading: Bool = false
    @State var pushToLogin = false
    
    var body: some View {
        NavigationView {
            ProgressViewOverlay(isLoading: $loading) {
                VStack {
                    ZStack {
                        Image("background_login")
                            .resizable()
                            .frame(maxWidth: .infinity, maxHeight: 200)
                            .aspectRatio(1 , contentMode: .fill)
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
                        TextFieldLabel(label: "Email", text: $email, placeholder: "Digite seu email.", keyboardType: .emailAddress, autoCapitalization: .none, autoCorrectionDisabled: true, isSecure: false, errors: $errors)
                        TextFieldLabel(label: "Senha", text: $password, placeholder: "Digite sua senha.", keyboardType: .default, autoCapitalization: .none, autoCorrectionDisabled: true, isSecure: true, errors: $errors)
                        if (errors.count > 0) {
                            ForEach(errors, id: \.self) { error in
                                Text(error)
                                    .foregroundColor(Color("Error"))
                                    .font(Font.custom("Rubik", size: 12))
                                    .fontWeight(.regular)
                            }
                        }
                        ZStack {
                            Button(action: {
                                logUserIn()
                            }) {
                                HStack {
                                    Text("ENTRAR")
                                        .font(Font.custom("Rubik", size: 16))
                                        .fontWeight(.medium)
                                }
                            }
                            .buttonStyle(LoginButtonStyle())
                            NavigationLink(destination: EnterpriseSearch(), isActive: $pushToLogin) {
                                EmptyView()
                            }
                            .hidden()
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
        if (email.isValidEmail()) {
            loginController.logUserIn(email: email, password: password) {
                (result: Result<LoginResponse, ErrorResponse>) in
                switch result{
                case .success(_):
                    pushToLogin = true
                    break
                case .failure(let parsedError):
                    if let _errors = parsedError.errors {
                        errors = _errors
                    }
                }
                loading = false
            }
        } else {
            errors = ["Este email n??o ?? v??lido."]
            loading = false
        }
        
    }
    
}

struct TextFieldLabel: View {
    @State var label: String
    @Binding var text: String
    @State var placeholder: String
    @State var keyboardType: UIKeyboardType
    @State var autoCapitalization: UITextAutocapitalizationType
    @State var autoCorrectionDisabled: Bool
    @State var isSecure: Bool
    @Binding var errors: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .foregroundColor(.black)
                .font(Font.custom("Rubik", size: 12))
                .fontWeight(.regular)
            if (!isSecure) {
                TextField(placeholder, text: $text)
                    .textFieldStyle(LoginTextFieldStyle(keyboardType: $keyboardType, autoCapitalization: $autoCapitalization, autoCorrectionDisabled: $autoCorrectionDisabled, error: .constant(errors.count > 0)))
            } else {
                SecureField(placeholder, text: $text)
                    .textFieldStyle(LoginTextFieldStyle(keyboardType: $keyboardType, autoCapitalization: $autoCapitalization, autoCorrectionDisabled: $autoCorrectionDisabled, error: .constant(errors.count > 0)))
            }
        }
    }
}

struct LoginTextFieldStyle: TextFieldStyle {
    @Binding var keyboardType: UIKeyboardType
    @Binding var autoCapitalization: UITextAutocapitalizationType
    @Binding var autoCorrectionDisabled: Bool
    @Binding var error: Bool
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(16)
            .keyboardType(keyboardType)
            .font(Font.custom("Rubik", size: 16))
            .background(RoundedRectangle(cornerRadius: 6).foregroundColor(Color("Gray 1")))
            .foregroundColor(.black)
            .autocapitalization(autoCapitalization)
            .disableAutocorrection(autoCorrectionDisabled)
            .if(error) { $0.overlay(RoundedRectangle(cornerRadius: 10).stroke(Color("Error"), lineWidth: 1)) }
    }
    
}

struct LoginButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(12)
            .frame(minWidth: 0, maxWidth: .infinity)
            .foregroundColor(.white)
            .background(configuration.isPressed ? Color("Pink 2") : Color("Pink 1"))
            .cornerRadius(6)
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
