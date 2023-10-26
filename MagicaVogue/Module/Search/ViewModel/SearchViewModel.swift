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
    
    var animationView: LottieAnimationView?
    var productArray: [Products]?
    var dataArray: [Products]?
    var onDataUpdate: (() -> Void)?
    
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
}
