//
//  ProductModel.swift
//  MagicaVogue
//
//  Created by Hoda Elnaghy on 10/23/23.
//

import Foundation

struct Images: Codable {
    let id: Int?
    let product_id: Int?
    let src: String?
}

struct ProductImage: Codable {
    let id: Int?
    let product_id: Int?
    let src: String?
}

struct Products: Codable {
    let id: Int?
    let title: String?
    let body_html: String?
    let product_type: String?
    let status: String?
    let images: [Images]?
    let image: ProductImage?
    let variants: [Variants]?
    let options:[Options]?
    
}
struct Product: Codable {
    let products: [Products]?
}

enum ProductTypes {
    
}

struct Variants: Codable {
    let id: Int
    let price: String?
}
struct Options:Codable{
   let name : String?
    let values : [String]?
}

//"options": [
//              {
//                  "id": 11157004583228,
//                  "product_id": 8857918734652,
//                  "name": "Size",
//                  "position": 1,
//                  "values": [
//                      "OS"
//                  ]
//              },
//              {
//                  "id": 11157004615996,
//                  "product_id": 8857918734652,
//                  "name": "Color",
//                  "position": 2,
//                  "values": [
//                      "black"
//                  ]
//              }
//          ]
