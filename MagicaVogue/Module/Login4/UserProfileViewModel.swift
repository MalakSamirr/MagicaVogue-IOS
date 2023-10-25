//
//  UserProfileViewModel.swift
//  MagicaVogue
//
//  Created by Heba Elcc on 25.10.2023.
//

import Foundation

enum profileSection {
    case welcomingMessage
    case orders
    case wishlist
    case header(title: String, actionTitle: String)
}

class UserProfileViewModel {
    var profileSection: [profileSection] = []
    
    func setSetions() {
        self.profileSection = [.welcomingMessage, .header(title: "Orders", actionTitle: "More"), .orders, .header(title: "Wishlist", actionTitle: "More"), .wishlist]
    }
}
