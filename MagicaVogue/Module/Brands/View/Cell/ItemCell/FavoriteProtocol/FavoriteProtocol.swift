//
//  FavoriteProtocol.swift
//  MagicaVogue
//
//  Created by Hoda Elnaghy on 10/25/23.
//

import Foundation
import Alamofire

protocol FavoriteProtocol {
    func playAnimation()
    func addToFavorite(_ id: Int)
    func deleteFromFavorite(_ itemId: Int)
    func deleteFromFavorite2(_ draftOrderId: Int)
}

extension FavoriteProtocol {
    func deleteFromFavorite2(_ draftOrderId: Int) {
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
 
                case .failure(let error):
                    print("Failed to delete Draft Order with ID \(draftOrderId). Error: \(error)")
                }
            }
    }

}
