//
//  PriceRuleModel.swift
//  MagicaVogue
//
//  Created by Shimaa Elcc on 26.10.2023.
//

import Foundation
struct PriceMRuleModel: Codable {
    let price_rule: PriceRule?
}

// MARK: - PriceRule
struct PriceRule: Codable {
    let id: Int?
    let valueType, value: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case valueType = "value_type"
        case value
    }
}
