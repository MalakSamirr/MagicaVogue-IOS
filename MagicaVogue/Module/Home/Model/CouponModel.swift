//
//  CouponModel.swift
//  MagicaVogue
//
//  Created by Shimaa Elcc on 26.10.2023.
//

import Foundation
struct CouponModel: Codable {
    let discount_codes: [DiscountCode]?
}

// MARK: - DiscountCode
struct DiscountCode: Codable {
    let id, priceRuleID: Int?
    let code: String?
    let usageCount: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case priceRuleID = "price_rule_id"
        case code
        case usageCount = "usage_count"
    }
}
