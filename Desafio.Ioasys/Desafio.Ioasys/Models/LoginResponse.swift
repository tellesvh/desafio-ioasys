//
//  LoginResponse.swift
//  Desafio.Ioasys
//
//  Created by Victor Hugo Telles on 01/10/20.
//

import Foundation

struct LoginResponse: Codable {
    var investor: Investor?
    var enterprise: String?
    var success: Bool?
}

struct Investor: Codable {
    var id: Int?
    var investorName: String?
    var email: String?
    var city: String?
    var balance: Decimal?
    var photo: String?
    var portfolio: Portfolio?
    var portfolioValue: Decimal?
    var firstAccess: Bool?
    var superAngel: Bool?
    
    enum CodingKeys: String, CodingKey {
        case investorName = "investor_name"
        case portfolioValue = "portfolio_value"
        case firstAccess = "first_access"
        case superAngel = "super_angel"
        
        case id
        case email
        case city
        case balance
        case photo
        case portfolio
    }
}

struct Portfolio: Codable {
    var enterprisesNumber: Int?
    var enterprises: [String]?
    
    enum CodingKeys: String, CodingKey {
        case enterprisesNumber = "enterprises_number"
        
        case enterprises
    }
}
