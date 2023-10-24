//
//  CategoryViewModel.swift
//  MagicaVogue
//
//  Created by Hoda Elnaghy on 10/24/23.
//

import Foundation

class CategoryViewModel {
    // MARK: - Variables
    var selectedIndexPath: IndexPath?
    var mainCategoryArray: [mainCategoryModel] = [
        mainCategoryModel(name: "All", isSelected: true, imageName: nil),
        mainCategoryModel(name: "Men", isSelected: false, imageName: nil),
        mainCategoryModel(name: "Women", isSelected: false, imageName: nil),
        mainCategoryModel(name: "Kids", isSelected: false, imageName: nil)
    ]
    
    var subCategoryArray: [SubCategoryModel] = [
        SubCategoryModel(type: "T-SHIRTS", isSelected: false),
        SubCategoryModel(type: "dress", isSelected: false),
        SubCategoryModel(type: "ACCESSORIES", isSelected: false),
        SubCategoryModel(type: "SHOES", isSelected: false),
        SubCategoryModel(type: "pants", isSelected: false)
    ]
    var selectedIndexPathForSubCategory: IndexPath?
    var productArray: [Products]?
    var dataArray: [Products]?
    var onDataUpdate: (() -> Void)?
    
    func filterProducts(byProductType productTypeToFilter: String) {
        productArray = self.dataArray?.filter { product in
            return product.product_type == productTypeToFilter
        }
        DispatchQueue.main.async {
            self.onDataUpdate?()
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
    
    func filterMainCategrories() {
        let selectedMainCategoryName = mainCategoryArray.first(where: { $0.isSelected })?.name
        switch selectedMainCategoryName {
        case "All":
            getCategories(url: "https://9ec35bc5ffc50f6db2fd830b0fd373ac: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@ios-q1-new-capital-2023.myshopify.com/admin/api/2023-01/products.json")
        case "Men":
            getCategories(url: "https://9ec35bc5ffc50f6db2fd830b0fd373ac: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@ios-q1-new-capital-2023.myshopify.com/admin/api/2023-01/products.json?collection_id=470653141308")
        case "Women":
            getCategories(url: "https://9ec35bc5ffc50f6db2fd830b0fd373ac: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@ios-q1-new-capital-2023.myshopify.com/admin/api/2023-01/products.json?collection_id=470653174076")
            
        case "Kids":
            getCategories(url: "https://9ec35bc5ffc50f6db2fd830b0fd373ac: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@ios-q1-new-capital-2023.myshopify.com/admin/api/2023-01/products.json?collection_id=470653206844")
        default:
            return
        }
    }


    
    
}
