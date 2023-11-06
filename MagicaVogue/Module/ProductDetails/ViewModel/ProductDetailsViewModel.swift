//
//  ProductDetailsViewModel.swift
//  MagicaVogue
//
//  Created by Gsm on 29/10/2023.
//

import Foundation
class ProductDetailsViewModel{
    var currentCell = 0
    var customerid = 7471279866172
    var selectedIndexPathForSize: IndexPath?
    var selectedIndexPathForColor: IndexPath?
    
    var timer: Timer?
    
    
    var productSizes: [ProductOption] = []
    var productColors: [ProductOption] = []
    
    var arrOfProductImgs: [String] = []
    var arrOfSize: [String] = []
    var arrOfColor: [String] = []
    
    var myProduct : Products!
    var cart: [Products] = []
    var wishlist: [DraftOrder] = []

    func getWishlist(completion: @escaping () -> Void) {
        if APIManager.shared.isOnline() {
            APIManager.shared.request(.get, "https://9ec35bc5ffc50f6db2fd830b0fd373ac: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@ios-q1-new-capital-2023.myshopify.com/admin/api/2023-10/draft_orders.json") { (result: Result<DraftOrderResponse, Error>) in
                switch result {
                case .success(let draftOrderResponse):
                    self.wishlist = draftOrderResponse.draft_orders.filter { $0.note == "Wishlist" && $0.customer?.id == 7471279866172 }
                    DispatchQueue.main.async {
                        // Call the completion handler when wishlist is fetched
                        completion()
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
            }
        } else {
            print("Not connected")
        }
    }
    
    
}

