//
//  CategoryViewModel.swift
//  MagicaVogue
//
//  Created by Hoda Elnaghy on 10/24/23.
//

import Foundation
import Lottie
import Alamofire

class CategoryViewModel {
    // MARK: - Variables
    var wishlist: [Products] = []
    var animationView: LottieAnimationView?
    var selectedIndexPath: IndexPath?
    var wishlistArray: [DraftOrder] = []
    var customeriD :Int?
    var mainCategoryArray: [mainCategoryModel] = [
        mainCategoryModel(id: 1, name: "All", isSelected: true, imageName: nil),
        mainCategoryModel(id: 2, name: "Men", isSelected: false, imageName: nil),
        mainCategoryModel(id: 3, name: "Women", isSelected: false, imageName: nil),
        mainCategoryModel(id: 4, name: "Kids", isSelected: false, imageName: nil)
    ]
    
    var subCategoryArray: [SubCategoryModel] = [
        SubCategoryModel(type: "T-SHIRTS", isSelected: false),
        SubCategoryModel(type: "ACCESSORIES", isSelected: false),
        SubCategoryModel(type: "SHOES", isSelected: false),
    ]
    var selectedIndexPathForSubCategory: IndexPath?
    var productArray: [Products]?
    var dataArray: [Products]?
    var onDataUpdate: (() -> Void)?
    
    init() {
        getWishlist {
            self.getCategories(url: "https://9ec35bc5ffc50f6db2fd830b0fd373ac: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@ios-q1-new-capital-2023.myshopify.com/admin/api/2023-01/products.json")
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
    
    func filterMainCategrories(_ productType: String = "") {
        let selectedMainCategoryName = mainCategoryArray.first(where: { $0.isSelected })?.name
        switch selectedMainCategoryName {
        case "All":
            if productType.isEmpty {
                getCategories(url: "https://9ec35bc5ffc50f6db2fd830b0fd373ac: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@ios-q1-new-capital-2023.myshopify.com/admin/api/2023-01/products.json")
            }
            else {
                getCategories(url: "https://9ec35bc5ffc50f6db2fd830b0fd373ac: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@ios-q1-new-capital-2023.myshopify.com/admin/api/2023-01/products.json?\(productType)")
                
            }
        case "Men":
            getCategories(url: "https://9ec35bc5ffc50f6db2fd830b0fd373ac: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@ios-q1-new-capital-2023.myshopify.com/admin/api/2023-01/products.json?collection_id=470653141308\(productType)")
        case "Women":
            getCategories(url: "https://9ec35bc5ffc50f6db2fd830b0fd373ac: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@ios-q1-new-capital-2023.myshopify.com/admin/api/2023-01/products.json?collection_id=470653174076\(productType)")
            
        case "Kids":
            getCategories(url: "https://9ec35bc5ffc50f6db2fd830b0fd373ac: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@ios-q1-new-capital-2023.myshopify.com/admin/api/2023-01/products.json?collection_id=470653206844\(productType)")
        default:
            return
        }
    }
    
    func getWishlist(completion: @escaping () -> Void) {
        if APIManager.shared.isOnline() {
            APIManager.shared.request(.get, "https://9ec35bc5ffc50f6db2fd830b0fd373ac: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@ios-q1-new-capital-2023.myshopify.com/admin/api/2023-10/draft_orders.json") { (result: Result<DraftOrderResponse, Error>) in
                switch result {
                case .success(let draftOrderResponse):
                    self.wishlistArray = draftOrderResponse.draft_orders.filter { $0.note == "Wishlist" && $0.customer?.id == self.customeriD }
                    print("wishlist\(self.wishlistArray.count)")
                    DispatchQueue.main.async {
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
    
    
//    func fillItems() {
//        if let pr = productArray {
//            for item in pr {
//                if let variantArray = item.variants {
//                    for variants in variantArray {
//                        editVariantQuantity(inventory_item_id: variants.inventory_item_id, new_quantity: 40) {
//                            print("HI")
//                        }
//                    }
//                }
//                else {
//                    
//                }
//                
//            }
//        }
//    }
//    
//    
//    
//    private func editVariantQuantity(inventory_item_id: Int, new_quantity : Int, Handler: @escaping () -> Void){
//            let urlFile = "https://ios-q1-new-capital-2023.myshopify.com/admin/api/2023-10/inventory_levels/adjust.json"
//            
//            let body: [String: Any] = [
//                
//                "location_id": 93685481788,
//                "inventory_item_id": inventory_item_id,
//                "available_adjustment": new_quantity
//            ]
//            
//            AF.request(urlFile,method: Alamofire.HTTPMethod.post, parameters: body, headers: ["X-Shopify-Access-Token":"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"]).response { data in
//                switch data.result {
//                case .success(_):
//                    print("success from edit variant")
//                    Handler()
//                    break
//                case .failure(let error):
//                    print("in edit varaint in network manager")
//                    print(error)
//                }
//            }
//        }
//    
//    
//    
}
