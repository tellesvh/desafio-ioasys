//
//  EnterprisesResponse.swift
//  Desafio.Ioasys
//
//  Created by Victor Hugo Telles on 02/10/20.
//

import Foundation

struct EnterprisesResponse: Codable {
    var enterprises: [Enterprise]?
}

struct Enterprise: Codable {
    var id: Int?
    var emailEnterprise: String?
    var facebook: String?
    var twitter: String?
    var linkedin: String?
    var phone: String?
    var ownEnterprise: Bool?
    var enterpriseName: String?
    var photo: String?
    var description: String?
    var city: String?
    var country: String?
    var value: Decimal?
    var sharePrice: Decimal?
    var enterpriseType: EnterpriseType?
    
    enum CodingKeys: String, CodingKey {
        case emailEnterprise = "email_enterprise"
        case ownEnterprise = "own_enterprise"
        case enterpriseName = "enterprise_name"
        case sharePrice = "share_price"
        case enterpriseType = "enterprise_type"
        
        case id
        case facebook
        case twitter
        case linkedin
        case phone
        case photo
        case description
        case city
        case country
        case value
    }
}

struct EnterpriseType: Codable {
    var id: Int?
    var enterpriseTypeName: String?
    
    enum CodingKeys: String, CodingKey {
        case enterpriseTypeName = "enterprise_type_name"
        
        case id
    }
}
