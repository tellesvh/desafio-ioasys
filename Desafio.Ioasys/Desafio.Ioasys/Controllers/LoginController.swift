//
//  LoginController.swift
//  Desafio.Ioasys
//
//  Created by Victor Hugo Telles on 01/10/20.
//

import Foundation
import KeychainSwift

class LoginController : ObservableObject {
    func logUserIn(email: String, password: String, completion: @escaping (Result<LoginResponse, ErrorResponse>) -> Void) {
        let body: [String : Any] = ["email": email, "password": password]
        
        HttpRequestPerformer(body: body, url: "users/auth/sign_in", method: .post).run() {
            (result: Response<LoginResponse, ErrorResponse>) in
            switch result {
            case .success(let loginResponse, let headers):
                let keychain = KeychainSwift()
                
                if let client = headers["client"] {
                    keychain.set(client, forKey: CLIENT_KEY)
                }
                
                if let accessToken = headers["access-token"] {
                    keychain.set(accessToken, forKey: ACCESS_TOKEN_KEY)
                }
                
                if let uid = headers["uid"] {
                    keychain.set(uid, forKey: UID_KEY)
                }
                
                completion(.success(loginResponse))
            case .failure(let parsedError, _):
                let defaultValue = ErrorResponse(success: false, errors: ["Ocorreu um erro não esperado."])
                completion(.failure(parsedError ?? defaultValue))
            }
        }
    }
}
