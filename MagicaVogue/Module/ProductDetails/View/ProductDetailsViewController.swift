//
//  ProductDetailsViewController.swift
//  MagicaVogue
//
//  Created by Malak Samir on 18/10/2023.
//

import UIKit
import Alamofire
import Kingfisher


protocol saveItemsToCart : AnyObject{
    func addItemsToCart()
}

class ProductDetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    
    
    @IBOutlet weak var optionsCollectionView: UICollectionView!
    @IBOutlet weak var sliderControlPage: UIPageControl!
  
    
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
        print(productDetailsViewModel.arrOfSize)
        print("--------------------")
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
        print(productDetailsViewModel.arrOfColor)
        productPrice.text = "$\(productDetailsViewModel.myProduct.variants?[0].price ?? "0")"
        productName.text = productDetailsViewModel.myProduct.title
        productDetails.text = productDetailsViewModel.myProduct.body_html
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: 1000)
        
        optionsCollectionView.dataSource = self
        optionsCollectionView.delegate = self
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "ProductImageCell", bundle: nil), forCellWithReuseIdentifier: "ProductImageCell")
        
        optionsCollectionView.register(UINib(nibName: "MainCategoryCell", bundle: nil), forCellWithReuseIdentifier: "MainCategoryCell")
        
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
            default:
                return self.colorsLayout()
            }
        }
        optionsCollectionView.setCollectionViewLayout(layout1, animated: true)
        sliderControlPage.numberOfPages = productDetailsViewModel.arrOfProductImgs.count
        
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
            return 2
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
                return 0
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
                cell.mainCategoryLabel.text = "empty"
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
            }
            else {
                for index in 0..<productDetailsViewModel.productColors.count {
                    productDetailsViewModel.productColors[index].isSelected = false
                }
                
                productDetailsViewModel.productColors[indexPath.row].isSelected = true
            }
            collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if collectionView == optionsCollectionView {
            let sectionHeaderArray: [String] = ["Size", "Color"]
            if kind == ProductDetailsViewController.sectionHeaderElementKind {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseIdentifier, for: indexPath) as! SectionHeader
                headerView.label.text = sectionHeaderArray[indexPath.section]
                return headerView
            }
        }
        return UICollectionReusableView()
    }
    
    
    @IBAction func AddToCartButtonPressed(_ sender: UIButton) {
        
        add()
        
        
    }
    
    
    
    //
    //    func add() {
    //        // Your Shopify API URL
    //        let baseURLString = "https://ios-q1-new-capital-2023.myshopify.com/admin/api/2023-10/draft_orders.json"
    //
    //        // Request headers
    //        let headers: HTTPHeaders = ["X-Shopify-Access-Token": "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"]
    //
    //        let imageSrc = myProduct.image?.src ?? "SHOES"
    //        print(imageSrc)
    //
    //        // Request body data
    //        let draftOrderData: [String: Any] = [
    //               "draft_order": [
    //                "note": "cart",
    //                   "line_items": [
    //                       [
    //                           "title": myProduct.title,
    //                           "price": myProduct.variants?[0].price ?? "0.0",
    //                           "quantity": 1
    //                       ]
    //                   ],
    //                   "applied_discount": [
    //                       "description": imageSrc ,
    //                       "value_type": "fixed_amount",
    //                       "value": "10.0",
    //                       "amount": "10.00",
    //                       "title": "Custom"
    //                   ],
    //                   "customer": [
    //                       "id": 7471279866172
    //                   ],
    //                   "use_customer_default_address": true
    //               ]
    //           ]
    //
    //        AF.request(baseURLString, method: .post, parameters: draftOrderData, encoding: JSONEncoding.default, headers: headers)
    //            .response { response in
    //                switch response.result {
    //                case .success:
    //
    //                    print("Product added to cart successfully.")
    //
    //                    self.showSuccessAlert()
    //
    //                case .failure(let error):
    //                    print("Failed to add the product to the cart. Error: \(error)")
    //                }
    //            }
    //    }
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
                        "quantity": 1
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
                    print("Product added to cart successfully.")
                    self.showSuccessAlert()
                    
                    // Append the product to the cart array
                    self.productDetailsViewModel.cart.append(self.productDetailsViewModel.myProduct)
                    
                case .failure(let error):
                    print("Failed to add the product to the cart. Error: \(error)")
                }
            }
    }
    
    func isProductInCart() -> Bool {
        // Check if the product with the same ID is already in the cart
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
        
        
        
    
}
