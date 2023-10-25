//
//  HomeViewModel.swift
//  MagicaVogue
//
//  Created by Hoda Elnaghy on 10/18/23.
//

import Foundation

class HomeViewModel {
    // weak var brandPassingDelegate: selectedBrand?
    var brandArray: [SmartCollection]?
    var dataArray: [SmartCollection]?
    var discountCodes: [DiscountCode]?
    var priceRule: PriceMRuleModel?
    var currentCell = 0
    let arrOfImgs = ["couponBackground5","couponBackground5", "couponBackground5"]
    var timer: Timer?
    var onDataUpdateBrand: (() -> Void)?
    var onDataUpdateCoupon: (() -> Void)?

    init() {
        getBrands()
        getPriceRule()
        getDiscountCodes()
    }
    
    func getBrands() {
            APIManager.shared.request(.get, "https://9ec35bc5ffc50f6db2fd830b0fd373ac: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@ios-q1-new-capital-2023.myshopify.com/admin/api/2023-01/smart_collections.json") { (result: Result<HomeModel, Error>) in
                switch result {
                case .success(let product):
                    self.brandArray = product.smart_collections
                    self.dataArray = product.smart_collections
                    DispatchQueue.main.async {
                        // Notify the view that data has been updated
                        self.onDataUpdateBrand?()
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
            }
        }
    
    func getDiscountCodes() {
        APIManager.shared.request(.get, "https://9ec35bc5ffc50f6db2fd830b0fd373ac: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@ios-q1-new-capital-2023.myshopify.com//admin/api/2023-10/price_rules/1405087318332/discount_codes.json") { (result: Result<CouponModel, Error>) in
            print(result)
            switch result {
            case .success(let couponModel):
                self.discountCodes = couponModel.discount_codes
                DispatchQueue.main.async {
                    // Notify the view that data has been updated
                    self.onDataUpdateCoupon?()
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
    func getPriceRule() {
        APIManager.shared.request(.get, "https://9ec35bc5ffc50f6db2fd830b0fd373ac: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@ios-q1-new-capital-2023.myshopify.com//admin/api/2023-10/price_rules/1405087318332.json") { (result: Result<PriceMRuleModel, Error>) in
            switch result {
            case .success(let priceRule):
                self.priceRule = priceRule
                DispatchQueue.main.async {
                    // Notify the view that data has been updated
                    self.onDataUpdateCoupon?()
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
}

protocol selectedBrand: AnyObject {
    func passTheSelectedBrand(brand: SmartCollection)
}
