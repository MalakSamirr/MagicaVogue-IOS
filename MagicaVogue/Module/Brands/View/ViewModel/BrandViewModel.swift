//
//  BrandViewModel.swift
//  MagicaVogue
//
//  Created by Hoda Elnaghy on 10/24/23.
//

import Foundation
import Lottie

class BrandViewModel {
    var myProduct : Products!
    var wishlist: [DraftOrder] = []
    var selectedIndexPath: IndexPath?
    var selectedIndexPathForSubCategory: IndexPath?
    var sortArray: [mainCategoryModel] = [
        mainCategoryModel(id: 1, name: "Low to high", isSelected: false, imageName: ""),
        mainCategoryModel(id: 2, name: "High to low", isSelected: false, imageName: "")
    ]
    var productArray: [Products]?
    var dataArray: [Products]?
    var onDataUpdate: (() -> Void)?
    var brand: SmartCollection?
    var animationView: LottieAnimationView?
    var customeriD :Int?
    
    init() {
        getWishlist {
            self.getCategories(url: "") {
                self.onDataUpdate
            }
        }
    }
    
    func getCategories(url: String, completion: @escaping () -> Void) {
        if let brandId = brand?.id {
            let stringId = String(brandId)
            
            APIManager.shared.request(.get, "https://9ec35bc5ffc50f6db2fd830b0fd373ac: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@ios-q1-new-capital-2023.myshopify.com/admin/api/2023-01/products.json?collection_id=\(brandId)") { (result: Result<Product, Error>) in
                switch result {
                case .success(let product):
                    self.productArray = product.products
                    self.dataArray = product.products
                    print(self.productArray?[0].variants ?? "")
                    DispatchQueue.main.async {
                        self.onDataUpdate?()
                        completion()
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
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
    
    func sortByPrice(id: Int) {
        guard let dataArray = dataArray else {
            return
        }
        if id == 1 {
            productArray = dataArray.sorted { (product1, product2) in
                if let price1 = Double(product1.variants?[0].price ?? ""),
                   let price2 = Double(product2.variants?[0].price ?? "") {
                    return price1 < price2
                } else {
                    return false
                }
            }
        }
            else {
                
                productArray = dataArray.sorted { (product1, product2) in
                    if let price1 = Double(product1.variants?[0].price ?? ""),
                       let price2 = Double(product2.variants?[0].price ?? "") {
                        return price1 > price2
                    } else {
                        return false
                    }
                }
        }
    }

}
