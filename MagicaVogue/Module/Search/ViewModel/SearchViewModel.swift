//
//  SearchViewModel.swift
//  MagicaVogue
//
//  Created by Hoda Elnaghy on 10/26/23.
//

import Foundation
import Lottie

class SearchViewModel {
    // MARK: - Variables
    var wishlist: [DraftOrder] = []
    let customeriD = 7471279866172
    var animationView: LottieAnimationView?
    var productArray: [Products]?
    var dataArray: [Products]?
    var onDataUpdate: (() -> Void)?
    
    
    init() {
        getWishlist {
            self.getCategories(url: "https://9ec35bc5ffc50f6db2fd830b0fd373ac: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@ios-q1-new-capital-2023.myshopify.com/admin/api/2023-01/products.json")
        }
    }
    
    func getCategories(url: String) {
            APIManager.shared.request(.get, url) { (result: Result<Product, Error>) in
                switch result {
                case .success(let product):
                    self.productArray = product.products
                    self.dataArray = product.products
                    print(self.productArray)
                    DispatchQueue.main.async {
                        // Notify the view that data has been updated
                        self.onDataUpdate?()
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
            }
        }
    func getWishlist(completion: @escaping () -> Void) {
        if APIManager.shared.isOnline() {
            APIManager.shared.request(.get, "https://9ec35bc5ffc50f6db2fd830b0fd373ac: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@ios-q1-new-capital-2023.myshopify.com/admin/api/2023-10/draft_orders.json") { (result: Result<DraftOrderResponse, Error>) in
                switch result {
                case .success(let draftOrderResponse):
                    self.wishlist = draftOrderResponse.draft_orders.filter { $0.note == "Wishlist" && $0.customer?.id == self.customeriD }
                    DispatchQueue.main.async {
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
