//
//  HomeModel.swift
//  MagicaVogue
//
//  Created by Hoda Elnaghy on 10/22/23.
//

import Foundation

struct SmartCollection : Codable {
    let id: Int?
    let title: String?
    let image: Image
}
struct HomeModel:Codable {
    let smart_collections: [SmartCollection]?
    
}
struct Image: Codable {
    let src: String?
}
