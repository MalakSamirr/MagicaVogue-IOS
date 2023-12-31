//
//  CartModel.swift
//  MagicaVogue
//
//  Created by Heba Elcc on 18.10.2023.
//

import Foundation
struct DraftOrderResponse: Codable {

    var draft_orders: [DraftOrder]
}

struct DraftOrder: Codable {
    let created_at : String?
    let id: Int
    let note: String?
    var line_items: [LineItem]
    let applied_discount: Discount?
    let total_price: String?
    let customer : customer?
}

struct LineItem: Codable {
    var product_id: Int?
    var id: Int?
    var variant_id: Int?
    var title: String
    var price: String?
    var grams : Int?
    var name: String
    var quantity: Int
    var isFavorite: Bool?
}

struct Discount: Codable {
    let description: String?
    let value_type: String?
    let value: String?
    let amount: String?
    let title: String?
}

struct customer : Codable {
    let id : Int?

}

struct DraftOrderCompleteItems {
    let variantId: Int?
    let image: String?
    let inventoryItemId: Int?
}
