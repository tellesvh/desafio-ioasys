//
//  ErrorResponse.swift
//  Desafio.Ioasys
//
//  Created by Victor Hugo Telles on 02/10/20.
//

import Foundation

struct ErrorResponse: Codable, Error {
    var success: Bool?
    var errors: [String]?
    
    init(success: Bool = false, errors: [String] = []) {
        self.success = success;
        self.errors = errors;
    }
}
