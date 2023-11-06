//
//  OrderModel.swift
//  MagicaVogue
//
//  Created by Hoda Elnaghy on 11/5/23.
//

import Foundation

struct OrderModel: Codable {
    let id: Int
    let total_price: String?
    let customer: customerOrders?
    let created_at: String?
}

struct customerOrders: Codable {
    let id: Int
    let created_at: String?
}

struct order: Codable {
    let orders: [OrderModel]
}
