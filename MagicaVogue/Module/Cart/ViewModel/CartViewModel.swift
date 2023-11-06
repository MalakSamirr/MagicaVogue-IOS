//
//  CartViewModel.swift
//  MagicaVogue
//
//  Created by Gsm on 06/11/2023.
//

import Foundation
import RxSwift
import RxRelay
import Alamofire

class CartViewModel{
    var refresh: PublishRelay<Void> = PublishRelay()
    var havingError: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    
    var selctedProduct: Products?
    var cart: [DraftOrder] = []
    var productDataArray: [SelectedProduct] = []
    var cartRestItems: [DraftOrderCompleteItems] = []
    var totalPrice: Double = 0
    var customer_id : Int?
    var price: Double? = 0.0
    
    
    
    func getCart(completion: @escaping ([SelectedProduct]) -> Void) {
        if APIManager.shared.isOnline() {
            APIManager.shared.request(.get, "https://9ec35bc5ffc50f6db2fd830b0fd373ac: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@ios-q1-new-capital-2023.myshopify.com/admin/api/2023-10/draft_orders.json") { [self] (result: Result<DraftOrderResponse, Error>) in
                switch result {
                case .success(let draftOrderResponse):
                    self.cart = draftOrderResponse.draft_orders.filter { $0.note == "cart" && $0.customer?.id == self.customer_id }
                    
                    // Fetch product data for each item in the cart
                    let dispatchGroup = DispatchGroup()
                    productDataArray = []
                    if !cart.isEmpty {
                        for item in cart[0].line_items {
                            dispatchGroup.enter()
                            
                            
                            getProductData(productId: item.product_id ?? 0, variantId: item.variant_id ?? 0) { selectedProduct in
                                if let selectedProduct = selectedProduct {
                                    productDataArray.append(selectedProduct)
                                }
                                dispatchGroup.leave()
                            }
                        }
                    }
                    
                    // Notify when all product data requests are completed
                    dispatchGroup.notify(queue: DispatchQueue.main) {
//                        updateTotalPriceLabel()
//                        self.totalPriceLabel.text = String(self.viewModel.totalPrice)
//                        self.CartTableView.reloadData()
                        completion(self.productDataArray)
                        self.refresh.accept(())

                    }
                    
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    completion([])
                }
            }
        } else {
            print("Not connected")
            completion([])
        }
    }
    func getProductData(productId: Int, variantId: Int, completion: @escaping (SelectedProduct?) -> Void) {
        let url = "https://9ec35bc5ffc50f6db2fd830b0fd373ac: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@ios-q1-new-capital-2023.myshopify.com/admin/api/2023-10/products/\(productId).json"
        
        getProductDetails(url: url) { result in
            switch result {
            case .success(let product):
                completion(product)
            case .failure:
                completion(nil)
            }
        }
    }
    func deleteDraftOrder(draftOrderId: Int, completion: @escaping (Error?) -> Void) {
        let baseURLString = "https://ios-q1-new-capital-2023.myshopify.com/admin/api/2023-10/draft_orders/\(draftOrderId).json"
        let headers: HTTPHeaders = ["X-Shopify-Access-Token": "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"]
        
        AF.request(baseURLString, method: .delete, headers: headers)
            .response { response in
                switch response.result {
                case .success:
                    print("Draft Order with ID \(draftOrderId) is deleted.")
                    completion(nil) // Call the completion handler with no error
                case .failure(let error):
                    print("Failed to delete Draft Order with ID \(draftOrderId). Error: \(error)")
                    completion(error) // Call the completion handler with the error
                }
            }
    }


    func getProductDetails(url: String, completion: @escaping (Result<SelectedProduct, Error>) -> Void) {
        APIManager.shared.request(.get, url) { result in
            completion(result)
        }
    }
    func deleteLineItemFromDraftOrder(draftOrderId: Int, lineItemId: Int) {
        // Your Shopify API URL
        let baseURLString = "https://ios-q1-new-capital-2023.myshopify.com/admin/api/2023-10/draft_orders/\(draftOrderId).json"
        
        let headers: HTTPHeaders = ["X-Shopify-Access-Token": "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"]
        
        if let draftOrderIndex = cart.firstIndex(where: { $0.id == draftOrderId }) {

            if (cart[draftOrderIndex].line_items.count==1){
                deleteDraftOrder(draftOrderId: draftOrderId) { error in
                    if let error = error {
                        // Handle the error, such as showing an alert to the user
                        print("Error deleting draft order: \(error)")
                    } else {
                        self.cart = []
                        self.refresh.accept(())

                    }
                }
                
                
            }
            else{
            if let lineItemIndex = cart[draftOrderIndex].line_items.firstIndex(where: { $0.id == lineItemId }) {
                cart[draftOrderIndex].line_items.remove(at: lineItemIndex)
                
                let draftOrderData: [String: Any] = [
                    "draft_order": [
                        "line_items": cart[draftOrderIndex].line_items
                    ]
                ]
                
                AF.request(baseURLString, method: .put, parameters: draftOrderData, encoding: JSONEncoding.default, headers: headers)
                    .response { response in
                        switch response.result {
                        case .success:
                            print("Line item with ID \(lineItemId) deleted from Draft Order with ID \(draftOrderId).")
                            self.refresh.accept(())
                            //  self.updateTotalPriceLabel()
                            
                            DispatchQueue.main.async {
                                self.refresh.accept(())
                                // self.CartTableView.reloadData()
                            }
                        case .failure(let error):
                            print("Failed to delete Line item with ID \(lineItemId). Error: \(error)")
                        }}
                    }
            }
            //self.refresh.accept(())
           
        }
    }


}
