//
//  CurrencyModel.swift
//  MagicaVogue
//
//  Created by Gsm on 30/10/2023.
//

import Foundation

struct Currency: Codable {
    var results: [String: Double]?
    let base: String?
    let ms: Int?
    let updated: String?
}
