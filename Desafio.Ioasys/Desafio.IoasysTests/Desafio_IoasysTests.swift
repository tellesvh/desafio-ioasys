//
//  Desafio_IoasysTests.swift
//  Desafio.IoasysTests
//
//  Created by Victor Hugo Telles on 29/09/20.
//

import XCTest
import Foundation
@testable import Desafio_Ioasys

class Desafio_IoasysTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testLogUserInWithValidCredentials() {
        let e = expectation(description: "Alamofire")
        let body: [String : Any] = ["email": "testeapple@ioasys.com.br", "password": "12341234"]
        
        HttpRequestPerformer(body: body, url: "users/auth/sign_in", method: .post).run() {
            (result: Response<LoginResponse, ErrorResponse>) in
            switch result {
            case .success(let loginResponse, _):
                XCTAssertNotNil(loginResponse)
                break
            case .failure(let parsedError, _):
                XCTFail(parsedError?.errors?.first ?? "Ocorreu um erro não esperado.")
            }
            e.fulfill()
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testLogUserInWithInvalidCredentials() {
        let e = expectation(description: "Alamofire")
        let body: [String : Any] = ["email": "testeapple@ioasys.com.br", "password": "0000"]
        
        HttpRequestPerformer(body: body, url: "users/auth/sign_in", method: .post).run() {
            (result: Response<LoginResponse, ErrorResponse>) in
            switch result {
            case .success(_, _):
                XCTFail("Credenciais válidas.")
                break
            case .failure(let parsedError, _):
                XCTAssertNotNil(parsedError?.errors?.first ?? "Ocorreu um erro não esperado.")
            }
            e.fulfill()
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testSearchEnterprises() {
        let e = expectation(description: "Alamofire Login")
        let body: [String : Any] = ["email": "testeapple@ioasys.com.br", "password": "12341234"]
        var headers: [String : String] = [:]
        
        HttpRequestPerformer(body: body, url: "users/auth/sign_in", method: .post).run() {
            (result: Response<LoginResponse, ErrorResponse>) in
            switch result {
            case .success(_, let _headers):
                if let client = _headers["client"] {
                    headers.updateValue(client, forKey: "client")
                }
                if let accessToken = _headers["access-token"] {
                    headers.updateValue(accessToken, forKey: "access-token")
                }
                if let uid = _headers["uid"] {
                    headers.updateValue(uid, forKey: "uid")
                }
            case .failure(let parsedError, _):
                XCTFail(parsedError?.errors?.first ?? "Ocorreu um erro não esperado.")
            }
            e.fulfill()
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
        
        let parameters: [String : Any] = ["name": ""]
        
        let f = expectation(description: "Alamofire Enterprises")
        
        HttpRequestPerformer(body: parameters, headers: headers, url: "enterprises", method: .get, requestType: .query).run() {
            (result: Response<EnterprisesResponse, ErrorResponse>) in
            switch result {
            case .success(let enterprisesResponse, _):
                XCTAssertNotNil(enterprisesResponse.enterprises)
            case .failure(let parsedError, _):
                XCTFail(parsedError?.errors?.first ?? "Ocorreu um erro não esperado.")
            }
            f.fulfill()
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
}
