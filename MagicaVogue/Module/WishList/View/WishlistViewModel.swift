//
//  WishlistViewModel.swift
//  MagicaVogue
//
//  Created by Heba Elcc on 4.11.2023.
//

import Foundation
import RxSwift
import RxRelay
import Alamofire

class WishlistViewModel {
    var refresh: PublishRelay<Void> = PublishRelay()
    var havingError: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    var wishlist: [DraftOrder] = []
    let userDefaults = UserDefaults.standard

    func getWishlist() {
        if APIManager.shared.isOnline() {
            APIManager.shared.request(.get, "https://9ec35bc5ffc50f6db2fd830b0fd373ac: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@ios-q1-new-capital-2023.myshopify.com/admin/api/2023-10/draft_orders.json") { (result: Result<DraftOrderResponse, Error>) in
                switch result {
                case .success(let draftOrderResponse):
                    // Filter draft orders with note: "Wishlist"
                    self.wishlist = draftOrderResponse.draft_orders.filter { $0.note == "Wishlist" && $0.customer?.id == self.userDefaults.integer(forKey: "customerID")}
                    DispatchQueue.main.async {
                        self.refresh.accept(())
                    }
                case .failure(let error):
                    self.havingError.accept(error.localizedDescription)
                }
            }
        } else {
            print("Not connected")
        }
    }
    
    
      func deleteDraftOrder(draftOrderId: Int) {
          // Your Shopify API URL
          let baseURLString = "https://ios-q1-new-capital-2023.myshopify.com/admin/api/2023-10/draft_orders/\(draftOrderId).json"
          
          // Request headers
          let headers: HTTPHeaders = ["X-Shopify-Access-Token": "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"]
          
          AF.request(baseURLString, method: .delete, headers: headers)
              .response { response in
                  switch response.result {
                  case .success:
                      // Successfully deleted the Draft Order
                      print("Draft Order with ID \(draftOrderId) deleted successfully.")
                      
                      // Update the local data source (remove the deleted item)
                      if let index = self.wishlist.firstIndex(where: { $0.id == draftOrderId }) {
                          self.wishlist.remove(at: index)
                      }
                      
                      // Reload the table view data outside the response block
                      DispatchQueue.main.async {
                          self.refresh.accept(())
                      }
                  case .failure(let error):
                      self.havingError.accept("Failed to delete Draft Order with ID \(draftOrderId). Error: \(error)")
                  }
              }
      }
}
