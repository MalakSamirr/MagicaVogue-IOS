//
//  CartModel.swift
//  MagicaVogue
//
//  Created by Heba Elcc on 18.10.2023.
//

import Foundation
struct DraftOrderResponse: Codable {

    let draft_orders: [DraftOrder]
}

struct DraftOrder: Codable {
    
    let id: Int
    let note: String?
    let line_items: [LineItem]
    let applied_discount: Discount

}

struct LineItem: Codable {
    let id: Int?
    let title: String
    let price: String?
    let grams : Int?
    let name: String
    let quantity: Int
}

struct Discount: Codable {
    let description: String
    let value_type: String
    let value: String
    let amount: String
    let title: String
}
