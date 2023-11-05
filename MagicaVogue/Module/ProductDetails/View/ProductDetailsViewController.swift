//
//  ProductDetailsViewController.swift
//  MagicaVogue
//
//  Created by Malak Samir on 18/10/2023.
//

import UIKit
import Alamofire
import Kingfisher
import Cosmos


protocol saveItemsToCart : AnyObject{
    func addItemsToCart()
}

class ProductDetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    var variantId: Int?
    var reviewArray : [review] = [review(reviewer: "Heba Elsisy", review: "Amazing product with good quality"), review(reviewer: "Hoda Elnaghy", review: "Like it!!"),review(reviewer: "Malak Samir", review: "Not Bad")]
    @IBOutlet weak var rate: CosmosView!
    var inventoryItemId: Int?
    var cart: [DraftOrder] = []
    var customer_id : Int = 7471279866172
    var lineItemsArr: [LineItem]? = []
    @IBOutlet weak var optionsCollectionView: UICollectionView!
    @IBOutlet weak var sliderControlPage: UIPageControl!
  
    
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productDetails: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
  
    
    var productDetailsViewModel: ProductDetailsViewModel = ProductDetailsViewModel()
    static let sectionHeaderElementKind = "section-header-element-kind"
    
   // private var timer: Timer?

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // sliderControlPage.numberOfPages = arrOfProductImgs.count
        rate.rating = Double.random(in: 0.0...5.0)
        
        for image in productDetailsViewModel.myProduct.images! {
            productDetailsViewModel.arrOfProductImgs.append(image.src ?? "")
        }
        
        self.optionsCollectionView.register(SectionHeader.self, forSupplementaryViewOfKind: ProductDetailsViewController.sectionHeaderElementKind, withReuseIdentifier: SectionHeader.reuseIdentifier)
        
        
        if let values = productDetailsViewModel.myProduct.options?[0].values, !values.isEmpty {
            var isFirstSize = true
            
            for size in values {
                productDetailsViewModel.arrOfSize.append(size)
                var productOption: ProductOption
                if isFirstSize {
                    productOption = ProductOption(name: size, isSelected: true)
                    isFirstSize = false
                }
                else {
                    productOption = ProductOption(name: size, isSelected: false)
                }
                
                productDetailsViewModel.productSizes.append(productOption)
            }
        }
      
        if let values = productDetailsViewModel.myProduct.options?[1].values, !values.isEmpty {
            var isFirstColor = true
            for color in values {
                productDetailsViewModel.arrOfColor.append(color)
                var productOption: ProductOption
                if isFirstColor {
                    productOption = ProductOption(name: color, isSelected: true)
                    isFirstColor = false
                } else {
                    productOption = ProductOption(name: color, isSelected: false)
                    
                }
                productDetailsViewModel.productColors.append(productOption)
            }
        }
       
        
        if let intValue = Double(productDetailsViewModel.myProduct.variants?[0].price ?? "0") {
       //     let newCurrencyValue = GlobalData.shared.NewCurrency[0].value
                // Check if you can cast the value from the dictionary as an Int.
                
            let userDefaults = UserDefaults.standard

            let customerID = userDefaults.integer(forKey: "customerID")
            let CurrencyValue = userDefaults.double(forKey: "CurrencyValue\(customerID)")
            let CurrencyKey = userDefaults.string(forKey: "CurrencyKey\(customerID)")
            
            let result = intValue * CurrencyValue
                let resultString = String(format: "%.2f", result)
            productPrice.text = "\(CurrencyKey ?? "") \(resultString)"
            }
        
        productName.text = productDetailsViewModel.myProduct.title
        productDetails.text = productDetailsViewModel.myProduct.body_html
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: 1000)
        
        optionsCollectionView.dataSource = self
        optionsCollectionView.delegate = self
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "ProductImageCell", bundle: nil), forCellWithReuseIdentifier: "ProductImageCell")
        
        optionsCollectionView.register(UINib(nibName: "MainCategoryCell", bundle: nil), forCellWithReuseIdentifier: "MainCategoryCell")
        optionsCollectionView.register(UINib(nibName: "ReviewCell", bundle: nil), forCellWithReuseIdentifier: "ReviewCell")
        
        // Add a section header to optionsCollectionView
        
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: collectionView.frame.width, height: 270)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .horizontal
        collectionView.setCollectionViewLayout(layout, animated: false)
        
        automaticSlide()
        setupPageControl()
        collectionView?.isPagingEnabled = true
        collectionView?.decelerationRate = .fast
        
        self.optionsCollectionView.register( SectionHeader.self, forSupplementaryViewOfKind: BrandViewController.sectionHeaderElementKind, withReuseIdentifier: SectionHeader.reuseIdentifier)
        
        let layout1 = UICollectionViewCompositionalLayout { sectionIndex, enviroment in
            switch sectionIndex {
            case 0:
                return self.sizeLayout()
            case 1:
                return self.colorsLayout()
            default:
                return self.reviewLayout()
                
            }
            
        }
        optionsCollectionView.setCollectionViewLayout(layout1, animated: true)
        sliderControlPage.numberOfPages = productDetailsViewModel.arrOfProductImgs.count
        newItemSelected()
        
    }
    
    private func setupPageControl() {
        sliderControlPage?.hidesForSinglePage = true
        sliderControlPage?.addTarget(self, action: #selector(pageControlHandle), for: .valueChanged)
    }
    
    @objc private func pageControlHandle(sender: UIPageControl) {
        let indexPath = IndexPath(row: sender.currentPage, section: 0)
        if let frame = collectionView?.layoutAttributesForItem(at: indexPath)?.frame {
            collectionView?.scrollRectToVisible(frame, animated: true)
        }
    }
    
    private func automaticSlide() {
        productDetailsViewModel.timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(slide), userInfo: nil, repeats: true)
    }
    
    @objc func slide() {
        if productDetailsViewModel.currentCell < productDetailsViewModel.arrOfProductImgs.count - 1 {
            productDetailsViewModel.currentCell += 1
        } else {
            productDetailsViewModel.currentCell = 0
        }
        sliderControlPage.currentPage = productDetailsViewModel.currentCell
        let indexPath = IndexPath(row: sliderControlPage.currentPage, section: 0)
        if let frame = collectionView?.layoutAttributesForItem(at: indexPath)?.frame {
            collectionView?.scrollRectToVisible(frame, animated: true)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.width
        sliderControlPage?.currentPage = Int(ceil(pageNumber))
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        sliderControlPage?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch collectionView {
        case self.collectionView:
            return 1
        case optionsCollectionView:
            return 3
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case self.collectionView:
            sliderControlPage.numberOfPages = productDetailsViewModel.arrOfProductImgs.count
            
            return productDetailsViewModel.arrOfProductImgs.count
        case optionsCollectionView:
            switch section {
            case 0:
                return productDetailsViewModel.arrOfSize.count
            case 1:
                return productDetailsViewModel.arrOfColor.count
            default:
                return reviewArray.count
            }
            
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case self.collectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductImageCell", for: indexPath) as! ProductImageCell
            let img = productDetailsViewModel.arrOfProductImgs[indexPath.row]
            if let imageUrl = URL(string: img) {
                cell.img.kf.setImage(with: imageUrl)
            }
            return cell
        case optionsCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCategoryCell", for: indexPath) as! MainCategoryCell
            switch indexPath.section {
            case 0:
                cell.mainCategoryLabel.text = productDetailsViewModel.arrOfSize[indexPath.row]
                if (productDetailsViewModel.productSizes[indexPath.row].isSelected) {
                    cell.mainCategoryLabel.textColor = .white
                    cell.mainCategoryBackgroundView.backgroundColor = UIColor(red: 0.36, green: 0.46, blue: 0.42, alpha: 1.0)
                    
                }
            case 1:
                if (productDetailsViewModel.productColors[indexPath.row].isSelected) {
                    cell.mainCategoryLabel.textColor = .white
                    cell.mainCategoryBackgroundView.backgroundColor = UIColor(red: 0.36, green: 0.46, blue: 0.42, alpha: 1.0)
                    
                }
                
                cell.mainCategoryLabel.text = productDetailsViewModel.arrOfColor[indexPath.row]
            default:
               let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
                
                cell2.reviewerLabel.text = reviewArray[indexPath.row].reviewer
                cell2.reviewLabel.text = reviewArray[indexPath.row].review
                return cell2
                
            }
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == optionsCollectionView {
            if (indexPath.section == 0){
                return CGSize(width: 50, height: 50)
            }else {
                return CGSize(width: 100, height: 50)
                
            }
        }
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if (collectionView == optionsCollectionView){
            
            return CGSize(width: collectionView.frame.width, height: 50)
        }
        return CGSize(width: 0, height: 0)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == optionsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCategoryCell", for: indexPath) as! MainCategoryCell
            
            if indexPath.section == 0 {
                for index in 0..<productDetailsViewModel.productSizes.count {
                    productDetailsViewModel.productSizes[index].isSelected = false
                }
                
                productDetailsViewModel.productSizes[indexPath.row].isSelected = true
                newItemSelected()
            }
            else {
                for index in 0..<productDetailsViewModel.productColors.count {
                    productDetailsViewModel.productColors[index].isSelected = false
                }
                
                productDetailsViewModel.productColors[indexPath.row].isSelected = true
                newItemSelected()
            }
            collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if collectionView == optionsCollectionView {
            let sectionHeaderArray: [String] = ["Size", "Color","Reviews"]
            if kind == ProductDetailsViewController.sectionHeaderElementKind {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseIdentifier, for: indexPath) as! SectionHeader
                headerView.label.text = sectionHeaderArray[indexPath.section]
                return headerView
            }
        }
        return UICollectionReusableView()
    }
    
    
    @IBAction func AddToCartButtonPressed(_ sender: UIButton) {
        
        
            
            getCart { [self] in
                if !cart.contains(where: { $0.line_items.contains { $0.variant_id == variantId } }) {
                    print("fuckkkk \(variantId)")
                    
                    
                   
                        
                        
                            if !cart.isEmpty {
                                updateDraftOrder()
                                
                                
                            } else {
                                add()
                            }
                        
                        
                    
                        } else {
                    showAlreadyInCartAlert()
                }
            }
        
    }
    
    func updateDraftOrder() {
        lineItemsArr = [] // Initialize lineItemsArr as an empty array

        if let firstDraftOrder = cart.first {
            for lineItem in firstDraftOrder.line_items {
                var lineitemPlaceholder = LineItem(id: lineItem.id,  variant_id: lineItem.variant_id ?? 0, title: lineItem.title, price: lineItem.price, grams: lineItem.grams, name: lineItem.name, quantity: lineItem.quantity)
                lineItemsArr?.append(lineitemPlaceholder)
            }
        }
        
        // Add the new line item to lineItemsArr
        var lineitemPlaceholder = LineItem(id: productDetailsViewModel.myProduct.id, variant_id: variantId ?? 0, title: productDetailsViewModel.myProduct.title ?? "", price: productDetailsViewModel.myProduct.variants?[0].price, grams: 1, name: productDetailsViewModel.myProduct.title ?? "", quantity: 3)
        lineItemsArr?.append(lineitemPlaceholder)

        // Prepare the lineItems array for the PUT request
        var lineItems: [[String: Any]] = []
        for lineItem in lineItemsArr ?? [] {
            let lineItemData: [String: Any] = [
                "title": lineItem.title,
                "price": lineItem.price,
                "quantity": 1,
                "variant_id": lineItem.variant_id,
                "product_id": lineItem.product_id
                
            ]
            lineItems.append(lineItemData)
            
            
        }
        

        edit(lineItem: lineItems)
        
        // Now you can use the 'lineItems' array in your PUT request.
        // Call the updateDraftOrder function with the 'lineItems' array to update the draft order.
    }
    
    




    func getCart(completion: @escaping () -> Void) {
        if APIManager.shared.isOnline() {
            APIManager.shared.request(.get, "https://9ec35bc5ffc50f6db2fd830b0fd373ac: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@ios-q1-new-capital-2023.myshopify.com/admin/api/2023-10/draft_orders.json") { [weak self] (result: Result<DraftOrderResponse, Error>) in
                if let self = self {
                    switch result {
                    case .success(let draftOrderResponse):
                        // Filter draft orders with note: "cart"
                        self.cart = draftOrderResponse.draft_orders.filter { $0.note == "cart" && $0.customer?.id == self.customer_id }
                        completion() // Call the completion handler after getting the response
                    case .failure(let error):
                        print("Request failed with error: \(error)")
                    }
                }
            }
        } else {
            completion()
        }
    }

    
    func edit(lineItem : [[String: Any]]) {
        let baseURLString = "https://ios-q1-new-capital-2023.myshopify.com/admin/api/2023-10/draft_orders/\(cart[0].id).json"
                
        
        let headers: HTTPHeaders = ["X-Shopify-Access-Token": "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"]
        
        let imageSrc = productDetailsViewModel.myProduct.image?.src ?? "SHOES"
        
        // Request body data
        let draftOrderData: [String: Any] = [
            "draft_order": [
                "line_items": lineItem
            ]
        ]
        
        AF.request(baseURLString, method: .put, parameters: draftOrderData, encoding: JSONEncoding.default, headers: headers)
            .response { response in
                switch response.result {
                case .success:
                    print("Product added to cart successfully.")
                    self.showSuccessAlert()
                    self.productDetailsViewModel.cart.append(self.productDetailsViewModel.myProduct)
                    
                    self.editVariantQuantity(inventory_item_id: self.inventoryItemId ?? 0, new_quantity: -1) {
                    }
                    
                case .failure(let error):
                    print("Failed to add the product to the cart. Error: \(error)")
                }
            }
    }
    
    func add() {
        let baseURLString = "https://ios-q1-new-capital-2023.myshopify.com/admin/api/2023-10/draft_orders.json"
        
        // Check if the product is already in the cart
        if isProductInCart() {
            showAlreadyInCartAlert()
            return
        }
        
        let headers: HTTPHeaders = ["X-Shopify-Access-Token": "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"]
        
        let imageSrc = productDetailsViewModel.myProduct.image?.src ?? "SHOES"
        
        // Request body data
        let draftOrderData: [String: Any] = [
            "draft_order": [
                "note": "cart",
                "line_items": [
                    [
                        "title": productDetailsViewModel.myProduct.title ?? "SHOES",
                        "price": productDetailsViewModel.myProduct.variants?[0].price ?? "0.0",
                        "quantity": 1,
                        "variant_id": variantId,
                        "sku": productDetailsViewModel.myProduct.image?.src,
                        "product_details": productDetailsViewModel.myProduct.id
                        
                    ]
                ],
                "applied_discount": [
                    "description": imageSrc,
                    "value_type": "fixed_amount",
                    "value": "10.0",
                    "amount": "10.00",
                    "title": "Custom"
                ],
                "customer": [
                    "id": 7471279866172
                ],
                "use_customer_default_address": true
            ]
        ]
        
        AF.request(baseURLString, method: .post, parameters: draftOrderData, encoding: JSONEncoding.default, headers: headers)
            .response { response in
                switch response.result {
                case .success:
                    self.showSuccessAlert()
                    
                    self.productDetailsViewModel.cart.append(self.productDetailsViewModel.myProduct)
                    self.editVariantQuantity(inventory_item_id: self.inventoryItemId ?? 0, new_quantity: -1) {
                    }
                    
                case .failure(let error):
                    print("Failed to add the product to the cart. Error: \(error)")
                }
            }
    }
    
    func isProductInCart() -> Bool {
        if let existingProduct = productDetailsViewModel.cart.first(where: { $0.id == productDetailsViewModel.myProduct.id }) {
            return true
        }
        return false
    }
    
    func showAlreadyInCartAlert() {
        let alertController = UIAlertController(
            title: "Product Already in Cart",
            message: "This product is already in your cart.",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    func showSuccessAlert() {
        let alertController = UIAlertController(
            title: "Success",
            message: "Product added to cart successfully!",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    func colorsLayout()-> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(100), heightDimension: .absolute(50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0)
        section.orthogonalScrollingBehavior = .continuous
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: BrandViewController.sectionHeaderElementKind, alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    
    
    
    
        func sizeLayout()-> NSCollectionLayoutSection {
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(50), heightDimension: .absolute(50))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0)
            section.orthogonalScrollingBehavior = .continuous
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: BrandViewController.sectionHeaderElementKind, alignment: .top)
            section.boundarySupplementaryItems = [sectionHeader]
            return section
        }
    func reviewLayout()-> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(70))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0)
        //section.orthogonalScrollingBehavior = .continuous
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: BrandViewController.sectionHeaderElementKind, alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
        
        
        
    
}


extension ProductDetailsViewController {
    func editVariantQuantity(inventory_item_id: Int, new_quantity : Int, Handler: @escaping () -> Void){
        let urlFile = "https://ios-q1-new-capital-2023.myshopify.com/admin/api/2023-10/inventory_levels/adjust.json"
        
        let body: [String: Any] = [
            
            "location_id": 93685481788,
            "inventory_item_id": inventory_item_id,
            "available_adjustment": new_quantity
        ]
        
        AF.request(urlFile,method: Alamofire.HTTPMethod.post, parameters: body, headers: ["X-Shopify-Access-Token":"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"]).response { data in
            switch data.result {
            case .success(_):
                print("success from edit variant")
                Handler()
                break
            case .failure(let error):
                print("in edit varaint in network manager")
                print(error)
            }
        }
    }
    func newItemSelected() {
        var chosenColors = productDetailsViewModel.productColors
            .filter { $0.isSelected }
            .map { $0.name }
            .joined(separator: ", ")
        
        var chosenSize = productDetailsViewModel.productSizes
            .filter { $0.isSelected }
            .map { $0.name }
            .joined(separator: ", ")
        
        var productTitle = "\(chosenSize) / \(chosenColors)"
        
        if let variant = productDetailsViewModel.myProduct.variants?.first(where: { $0.title == productTitle }) {
            variantId = variant.id
            print("fuckkkk \(productTitle)\(variantId)")
            inventoryItemId = variant.inventory_item_id
            let inventoryQuantity = variant.inventory_quantity
            let productId = productDetailsViewModel.myProduct.id
            if inventoryQuantity <= 0 {
                addToCartButton.isEnabled = false
            }
        }
    }
}

protocol quantityChanged {
    func plusButton (inventoryItemId: Int, varientId: Int)
    func minusButton (inventoryItemId: Int, varientId: Int)
}

extension quantityChanged {
    func plusButton (inventoryItemId: Int, varientId: Int) {
        
    }

    
    
    
    
    
    private func editVariantQuantity(inventory_item_id: Int, new_quantity : Int, Handler: @escaping () -> Void){
            let urlFile = "https://ios-q1-new-capital-2023.myshopify.com/admin/api/2023-10/inventory_levels/adjust.json"
            
            let body: [String: Any] = [
                
                "location_id": 93685481788,
                "inventory_item_id": inventory_item_id,
                "available_adjustment": new_quantity
            ]
            
            AF.request(urlFile,method: Alamofire.HTTPMethod.post, parameters: body, headers: ["X-Shopify-Access-Token":"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"]).response { data in
                switch data.result {
                case .success(_):
                    print("success from edit variant")
                    Handler()
                    break
                case .failure(let error):
                    print("in edit varaint in network manager")
                    print(error)
                }
            }
        }
}
