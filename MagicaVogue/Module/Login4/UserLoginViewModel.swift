//
//  UserLoginViewModel.swift
//  MagicaVogue
//
//  Created by Shimaa Elcc on 5.11.2023.
//

import Foundation
import RxSwift
import RxRelay
import Alamofire

class UserLoginViewModel {
    var refreshOrdersTableView: PublishRelay<Void> = PublishRelay()
    var refreshWishlistCollectionView: PublishRelay<Void> = PublishRelay()
    var havingError: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    
    var cart: [DraftOrder] = []
    var wishlist: [DraftOrder] = []
    var CustomersArray: [customers]?

    func getCart() {
        if APIManager.shared.isOnline() {
            APIManager.shared.request(.get, "https://9ec35bc5ffc50f6db2fd830b0fd373ac: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@ios-q1-new-capital-2023.myshopify.com/admin/api/2023-10/draft_orders.json") { [self] (result: Result<DraftOrderResponse, Error>) in
                switch result {
                case .success(let draftOrderResponse):
                    // Filter draft orders with note: "cart"
                    self.cart = draftOrderResponse.draft_orders.filter { $0.note == "cart" }
                    
                    // Reload the data in the loginOrdersTableView
                    DispatchQueue.main.async {
                        self.refreshOrdersTableView.accept(())
                    }
                case .failure(let error):
                    self.havingError.accept("Request failed with error: \(error.localizedDescription)")
                }
            }
        } else {
            print("Not connected")
        }
    }
    
    func getWishlist() {
        if APIManager.shared.isOnline() {
            APIManager.shared.request(.get, "https://9ec35bc5ffc50f6db2fd830b0fd373ac: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@ios-q1-new-capital-2023.myshopify.com/admin/api/2023-10/draft_orders.json") { (result: Result<DraftOrderResponse, Error>) in
                switch result {
                case .success(let draftOrderResponse):
                    // Filter draft orders with note: "Wishlist"
                    self.wishlist = draftOrderResponse.draft_orders.filter { $0.note == "Wishlist" }
                    DispatchQueue.main.async {
                        self.refreshWishlistCollectionView.accept(())
                    }
                case .failure(let error):
                    self.havingError.accept("Request failed with error: \(error.localizedDescription)")
                }
            }
        } else {
            print("Not connected")
        }
    }
    
}


