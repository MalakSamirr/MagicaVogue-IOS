//
//  BrandViewModel.swift
//  MagicaVogue
//
//  Created by Hoda Elnaghy on 10/24/23.
//

import Foundation
import Lottie

class BrandViewModel {

    var selectedIndexPath: IndexPath?
    var selectedIndexPathForSubCategory: IndexPath?
    let sortingArray = ["Price", "Popular"]
    var productArray: [Products]?
    var dataArray: [Products]?
    var onDataUpdate: (() -> Void)?
    var brand: SmartCollection?
    var animationView: LottieAnimationView?
    
    func getCategories(url: String) {
        if let brandId = brand?.id {
            let stringId = String(brandId)
            
            APIManager.shared.request(.get, "https://9ec35bc5ffc50f6db2fd830b0fd373ac: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@ios-q1-new-capital-2023.myshopify.com/admin/api/2023-01/collections/\(brandId)/products.json") { (result: Result<Product, Error>) in
                switch result {
                case .success(let product):
                    self.productArray = product.products
                    self.dataArray = product.products
                    DispatchQueue.main.async {
                        self.onDataUpdate?()
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
            }
        }
    }
}
