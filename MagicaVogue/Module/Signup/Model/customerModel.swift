//
//  customerModel.swift
//  MagicaVogue
//
//  Created by Gsm on 02/11/2023.
//

import Foundation
struct Customer: Codable {
    let customers: [customers]?
    let addresses: [Address]?

    enum CodingKeys: String, CodingKey {
        case customers = "customers"
        case addresses = "addresses"
    }
}

struct customers: Codable {
    let id: Int?
    let first_name: String?
    let last_name: String?
    let email: String?
    let tags: String?
    let phone: String?
    let currency: String?
    let addresses: [Address]?

    enum CodingKeys: String, CodingKey {
        case id
        case first_name = "first_name"
        case last_name = "last_name"
        case email
        case tags
        case phone
        case currency
        case addresses
    }
}

struct Address: Codable , Equatable {
    let id: Int?
    let customer_id: Int?
    let first_name: String?
    let last_name: String?
    let company: String?
    let address1: String?
    let address2: String?
    let city: String?
    let province: String?
    let country: String?
    let zip: String?
    let phone: String?
    let name: String?
    let province_code: String?
    let country_code: String?
    let country_name: String?
    var isDefault: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case customer_id
        case first_name
        case last_name
        case company
        case address1
        case address2
        case city
        case province
        case country
        case zip
        case phone
        case name
        case province_code
        case country_code
        case country_name
        case isDefault = "default"
    }
    
}
//"addresses": [
//                {
//                    "id": 9672369471804,
//                    "customer_id": 7471287075132,
//                    "first_name": "Mother",
//                    "last_name": "Lastnameson",
//                    "company": null,
//                    "address1": "123 Oak St",
//                    "address2": null,
//                    "city": "Ottawa",
//                    "province": "Ontario",
//                    "country": "Canada",
//                    "zip": "123 ABC",
//                    "phone": "+15142546014",
//                    "name": "Mother Lastnameson",
//                    "province_code": "ON",
//                    "country_code": "CA",
//                    "country_name": "Canada",
//                    "default": true
//                }
