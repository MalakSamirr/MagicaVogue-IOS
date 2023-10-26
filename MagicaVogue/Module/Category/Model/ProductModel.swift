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
