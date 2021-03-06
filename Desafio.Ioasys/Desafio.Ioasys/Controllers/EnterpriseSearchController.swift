//
//  EnterpriseSearchController.swift
//  Desafio.Ioasys
//
//  Created by Victor Hugo Telles on 02/10/20.
//

import Foundation
import KeychainSwift

class EnterpriseSearchController : ObservableObject {
    func searchEnterprises(query: String, completion: @escaping (Result<[Enterprise], ErrorResponse>) -> Void) {
        let keychain = KeychainSwift()
        var headers: [String : String] = [:]
        let parameters: [String : Any] = ["name": query]
        
        if let client = keychain.get(CLIENT_KEY) {
            headers.updateValue(client, forKey: "client")
        }
        
        if let accessToken = keychain.get(ACCESS_TOKEN_KEY) {
            headers.updateValue(accessToken, forKey: "access-token")
        }
        
        if let uid = keychain.get(UID_KEY) {
            headers.updateValue(uid, forKey: "uid")
        }
        
        HttpRequestPerformer(body: parameters, headers: headers, url: "enterprises", method: .get, requestType: .query).run() {
            (result: Response<EnterprisesResponse, ErrorResponse>) in
            switch result {
            case .success(let enterprisesResponse, _):
                if let enterprises = enterprisesResponse.enterprises {
                    completion(.success(enterprises))
                } else {
                    completion(.success([]))
                }
            case .failure(let parsedError, _):
                let defaultValue = ErrorResponse(success: false, errors: ["Ocorreu um erro não esperado."])
                completion(.failure(parsedError ?? defaultValue))
            }
        }
    }
}
