//
//  FavoriteProtocol.swift
//  MagicaVogue
//
//  Created by Hoda Elnaghy on 10/25/23.
//

import Foundation

protocol FavoriteProtocol {
    func playAnimation()
    func addToFavorite(_ id: Int)
    func deleteFromFavorite(_ itemId: Int)
    
}

