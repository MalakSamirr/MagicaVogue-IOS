//
//  OrderModel.swift
//  MagicaVogue
//
//  Created by Hoda Elnaghy on 11/5/23.
//

import Foundation

struct OrderModel: Codable {
    let id: Int
    let total_line_items_price: String?
    let customer: customerOrders?
}

struct customerOrders: Codable {
    let id: Int
    let created_at: String?
}

struct order: Codable {
    let orders: [OrderModel]
}
