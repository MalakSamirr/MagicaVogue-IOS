//
//  ProductDetailsViewController.swift
//  MagicaVogue
//
//  Created by Malak Samir on 18/10/2023.
//

import UIKit
import Alamofire

protocol saveItemsToCart : AnyObject{
    func addItemsToCart()
}

class ProductDetailsViewController: UIViewController , UICollectionViewDelegate,UICollectionViewDataSource , UICollectionViewDelegateFlowLayout ,UIScrollViewDelegate {
    

    @IBOutlet weak var sliderControlPage: UIPageControl!
    var currentCell = 0
    var customerid = 7471279866172
    private var timer: Timer?
    
    let arrOfImgs = ["3","1","2"]
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var small: UIButton!
    
    @IBOutlet weak var medium: UIButton!
    
    
    @IBOutlet weak var large: UIButton!
    
    var myProduct : Products!
    var cart: [Products] = []

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("-----------malak---------")
        
        print (myProduct.id)
        print("-----------malak---------")

        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: 1000)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "ProductImageCell", bundle: nil), forCellWithReuseIdentifier: "ProductImageCell")
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width:collectionView.frame.width , height: 270)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .horizontal 
        collectionView.setCollectionViewLayout(layout, animated: false)
        
        automaticSlide()
        setupPageControl()
        collectionView?.isPagingEnabled = true
                collectionView?.decelerationRate = .fast

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
        
        private func automaticSlide () {
            timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(slide), userInfo: nil, repeats: true)
        }
        
        @objc func slide() {
            if currentCell < arrOfImgs.count - 1 {
                currentCell += 1
            } else {
                currentCell = 0
            }
            sliderControlPage.currentPage = currentCell
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductImageCell" , for: indexPath) as! ProductImageCell
        
        cell.img.image = UIImage(named: arrOfImgs[indexPath.row])
        return cell
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

        let imageSrc = myProduct.image?.src ?? "SHOES"

        // Request body data
        let draftOrderData: [String: Any] = [
           "draft_order": [
            "note": "cart",
               "line_items": [
                   [
                    "title": myProduct.title ?? "SHOES",
                       "price": myProduct.variants?[0].price ?? "0.0",
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
                    self.cart.append(self.myProduct)
                    
                case .failure(let error):
                    print("Failed to add the product to the cart. Error: \(error)")
                }
            }
    }

    func isProductInCart() -> Bool {
        // Check if the product with the same ID is already in the cart
        if let existingProduct = cart.first(where: { $0.id == myProduct.id }) {
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


}
