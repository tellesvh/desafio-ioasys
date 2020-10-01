//
//  LoginController.swift
//  Desafio.Ioasys
//
//  Created by Victor Hugo Telles on 01/10/20.
//

import Foundation

class LoginController : ObservableObject {
    func logUserIn(email: String, password: String, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        let body: [String : Any] = ["email": email, "password": password]
        
        HttpRequestPerformer(body: body, url: "/users/auth/sign_in", method: .post).run() {
            (result: Response<LoginResponse>) in
            switch result {
                case .success(let loginResponse, let headers):
                    // TODO Salvar headers de forma segura (client, access-token, uid)
                    print(headers)
                    completion(.success(loginResponse))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
}
