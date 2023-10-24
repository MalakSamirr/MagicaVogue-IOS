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
    var currentCell = 0
    let arrOfImgs = ["couponBackground5","couponBackground5", "couponBackground5"]
    var timer: Timer?
    var onDataUpdate: (() -> Void)?
    func getBrands(url: String) {
            APIManager.shared.request(.get, url) { (result: Result<HomeModel, Error>) in
                switch result {
                case .success(let product):
                    self.brandArray = product.smart_collections
                    self.dataArray = product.smart_collections
                    DispatchQueue.main.async {
                        // Notify the view that data has been updated
                        
                        self.onDataUpdate?()
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
