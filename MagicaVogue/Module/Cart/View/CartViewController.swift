//
//  CartViewController.swift
//  MagicaVogue
//
//  Created by Heba Elcc on 18.10.2023.
//

import UIKit
import Alamofire
import Kingfisher
import Firebase
import FirebaseAuth

class CartViewController: UIViewController , UITableViewDataSource , UITableViewDelegate {
    @IBOutlet weak var checkoutButton: UIButton!
    var selctedProduct: Products?
    var cart: [DraftOrder] = []
    var productDataArray: [SelectedProduct] = []
    var cartRestItems: [DraftOrderCompleteItems] = []
    var totalPrice: Double = 0
    var customer_id : Int?
    var price: Double? = 0.0
    @IBOutlet weak var CartTableView: UITableView!
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Cart"
        
        self.navigationController?.navigationBar.backgroundColor = .white
        CartTableView.delegate = self
        CartTableView.dataSource = self
        CartTableView.register(UINib(nibName: "CartCell", bundle: nil), forCellReuseIdentifier: "CartCell")
        

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        for item in productDataArray {
            print("akhhhh\(item.product.image?.src)")
        }
        if (Auth.auth().currentUser == nil){
            let alert1 = UIAlertController(
                title: "Login first", message: "you should login you account first!", preferredStyle: UIAlertController.Style.alert)
            
            let loginAction = UIAlertAction(title: "Login Now" , style : .default) { (action) in
                
                if let sceneDelegate = UIApplication.shared.connectedScenes
                            .first?.delegate as? SceneDelegate {
                            sceneDelegate.resetAppNavigation()
                        }
            }
            alert1.addAction(loginAction)
            present(alert1, animated: true , completion: nil)
            return
        }
            else{
                let userDefaults = UserDefaults.standard

                customer_id = 7471279866172
                getCart {_ in
                    self.CartTableView.reloadData()
                    for item in self.productDataArray {
                        print("akhhhh\(item.product.image?.src)")
                    }
                }
            }
//        if cart.isEmpty {
//            checkoutButton.isEnabled = false
//        } else {
//            checkoutButton.isEnabled = true
//
//        }
    }
  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !cart.isEmpty, let firstDraftOrder = cart.first {
               return firstDraftOrder.line_items.count
           } else {
               return 0
           }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
        cell.lineItemsDelegate = self
        if indexPath.row < cart[0].line_items.count {
            let draftOrder = cart[0].line_items[indexPath.row]
            cell.productNameLabel.text = draftOrder.title
           // cell.productPriceLabel.text = draftOrder.price
            cell.setupUI(lineItem: draftOrder)
            cell.productPrice = Double(draftOrder.price ?? "0")
            
            
            let targetProductId = cart[0].line_items[indexPath.row].product_id
            
            if let filteredProduct = productDataArray.first(where: { $0.product.id == targetProductId }) {
                let imageUrlString = filteredProduct.product.image?.src
                if let imageUrl = URL(string: imageUrlString ?? "") {
                    print("ewwwwwww \(filteredProduct)")
                    cell.productImageView.kf.setImage(with: imageUrl)
                }
                
                if let filteredVariant = filteredProduct.product.variants?.first(where: {
                        $0.id == cart[0].line_items[indexPath.row].variant_id
                        
                }) {
                    cell.maxQuantity = Double(filteredVariant.inventory_quantity)
                    print("ewwwwwwwwwwww\(Double(filteredVariant.inventory_quantity))")
                    cell.inventoryItemId = filteredVariant.inventory_item_id
                    cell.sizeLabel.isHidden = false
                    cell.sizeLabel.text = "Details: \(filteredVariant.title ?? "")"
                }
            } else {
                
            }
            
             // Initialize with a default value

            if indexPath.row == 0 {
                price = Double(cell.productPriceLabel.text ?? "0") ?? 0
            } else {
                if let cellPrice = Double(cell.productPriceLabel.text ?? "0") {
                    price = (price ?? 0.0) + cellPrice
                }
            }

            if indexPath.row == cart[0].line_items.count - 1 {
                if let totalPrice = price {
                    let stringPrice = String(totalPrice)
                    totalPriceLabel.text = stringPrice
                } else {
                }
            }

        }
        
        return cell
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alertController = UIAlertController(
                title: "Delete Item",
                message: "Are you sure you want to remove this item from your shopping bag?",
                preferredStyle: .actionSheet
            )

            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
                if let draftOrderId = self?.cart[0].id,
                   let lineItemId = self?.cart[0].line_items[indexPath.row].id {
                    self?.deleteLineItemFromDraftOrder(draftOrderId: draftOrderId, lineItemId: lineItemId)
                    self?.updateDraftOrder(lineItemsArr: (self?.cart[0].line_items)!)
                    DispatchQueue.main.async {
                        self?.CartTableView.reloadData()
                    }
                    
                }
            }

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

            alertController.addAction(deleteAction)
            alertController.addAction(cancelAction)

            if let popoverController = alertController.popoverPresentationController {
                if let cell = tableView.cellForRow(at: indexPath) {
                    popoverController.sourceView = cell
                    popoverController.sourceRect = cell.bounds
                }
            }

            present(alertController, animated: true, completion: nil)
        }
    }




    
    @IBAction func Checkout(_ sender: UIButton) {
        
        
        let checkoutVC = CheckoutVC()
            checkoutVC.cart = self.cart
            checkoutVC.productDataArray = self.productDataArray
        checkoutVC.totalPrice = price ?? 0
          navigationController?.pushViewController(checkoutVC, animated: true)
        
    }
    
    func getCart(completion: @escaping ([SelectedProduct]) -> Void) {
        if APIManager.shared.isOnline() {
            APIManager.shared.request(.get, "https://9ec35bc5ffc50f6db2fd830b0fd373ac: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@ios-q1-new-capital-2023.myshopify.com/admin/api/2023-10/draft_orders.json") { [self] (result: Result<DraftOrderResponse, Error>) in
                switch result {
                case .success(let draftOrderResponse):
                    self.cart = draftOrderResponse.draft_orders.filter { $0.note == "cart" && $0.customer?.id == self.customer_id }
                    
                    // Fetch product data for each item in the cart
                    let dispatchGroup = DispatchGroup()
                    productDataArray = []
                    if !cart.isEmpty {
                        for item in cart[0].line_items {
                            dispatchGroup.enter()
                            
                            
                            getProductData(productId: item.product_id ?? 0, variantId: item.variant_id ?? 0) { selectedProduct in
                                if let selectedProduct = selectedProduct {
                                    productDataArray.append(selectedProduct)
                                }
                                dispatchGroup.leave()
                            }
                        }
                    }
                    
                    // Notify when all product data requests are completed
                    dispatchGroup.notify(queue: DispatchQueue.main) {
                        updateTotalPriceLabel()
                        self.totalPriceLabel.text = String(self.totalPrice)
                        self.CartTableView.reloadData()
                        print("fuckkkkkkkkkkkk\(productDataArray.count)")
                        completion(productDataArray)
                    }
                    
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    completion([])
                }
            }
        } else {
            print("Not connected")
            completion([])
        }
    }

    
    func deleteLineItemFromDraftOrder(draftOrderId: Int, lineItemId: Int) {
        // Your Shopify API URL
        let baseURLString = "https://ios-q1-new-capital-2023.myshopify.com/admin/api/2023-10/draft_orders/\(draftOrderId).json"
        
        let headers: HTTPHeaders = ["X-Shopify-Access-Token": "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"]
        
        if let draftOrderIndex = cart.firstIndex(where: { $0.id == draftOrderId }) {

            if let lineItemIndex = cart[draftOrderIndex].line_items.firstIndex(where: { $0.id == lineItemId }) {
                cart[draftOrderIndex].line_items.remove(at: lineItemIndex)
                
                let draftOrderData: [String: Any] = [
                    "draft_order": [
                        "line_items": cart[draftOrderIndex].line_items
                    ]
                ]
                
                AF.request(baseURLString, method: .put, parameters: draftOrderData, encoding: JSONEncoding.default, headers: headers)
                    .response { response in
                        switch response.result {
                        case .success:
                            print("Line item with ID \(lineItemId) deleted from Draft Order with ID \(draftOrderId).")
                            
                            self.updateTotalPriceLabel()
                            
                            DispatchQueue.main.async {
                                self.CartTableView.reloadData()
                            }
                        case .failure(let error):
                            print("Failed to delete Line item with ID \(lineItemId). Error: \(error)")
                        }
                    }
            }
        }
    }



    func updateTotalPriceLabel() {
            // Calculate the total price based on the items in the cart
            totalPrice = cart.reduce(0) { (total, draftOrder) in
                if let itemPrice = Double(draftOrder.line_items.first?.price ?? "0") {
                    return total + itemPrice
                }
                return total
            }
            totalPriceLabel.text = "\(totalPrice)"
        }
    func updateDraftOrder(lineItemsArr : [LineItem]) {
        
        var lineItems: [[String: Any]] = []

        for lineItem in lineItemsArr ?? [] {
            print("ewwww \(lineItem.product_id)")
            let lineItemData: [String: Any] = [
                "title": lineItem.title,
                "price": lineItem.price,
                "quantity": lineItem.quantity,
                "variant_id": lineItem.variant_id,
                "product_id": lineItem.product_id
            ]
            lineItems.append(lineItemData)
            
            
        }
        
        print("hhhhhhhhhhhhhh\(lineItems)")

        edit(lineItem: lineItems)
        
        // Now you can use the 'lineItems' array in your PUT request.
        // Call the updateDraftOrder function with the 'lineItems' array to update the draft order.
    }
    func edit(lineItem : [[String: Any]]) {
        let baseURLString = "https://ios-q1-new-capital-2023.myshopify.com/admin/api/2023-10/draft_orders/\(cart[0].id).json"
                
        
        let headers: HTTPHeaders = ["X-Shopify-Access-Token": "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"]
        
        
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
                case .failure(let error):
                    print("Failed to add the product to the cart. Error: \(error)")
                }
            }
    }
    func showSuccessAlert() {
        let alertController = UIAlertController(
            title: "Success",
            message: "Product deleted from cart successfully!",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        print("HHH")
    }
    
}

extension CartViewController {
    func getProductDetails(url: String, completion: @escaping (Result<SelectedProduct, Error>) -> Void) {
        APIManager.shared.request(.get, url) { result in
            completion(result)
        }
    }

    
    func getProductData(productId: Int, variantId: Int, completion: @escaping (SelectedProduct?) -> Void) {
        let url = "https://9ec35bc5ffc50f6db2fd830b0fd373ac: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@ios-q1-new-capital-2023.myshopify.com/admin/api/2023-10/products/\(productId).json"
        
        getProductDetails(url: url) { result in
            switch result {
            case .success(let product):
                completion(product)
            case .failure:
                completion(nil)
            }
        }
    }


    
}

protocol updateLineItemsProtocol {
    func edit(lineItem : [[String: Any]])
    func updateQuantity(lineItemID: Int, quantity: Int, totalPrice: String)
}

extension CartViewController: updateLineItemsProtocol {
    func updateQuantity(lineItemID: Int, quantity: Int, totalPrice: String) {
        DispatchQueue.main.async {
            // update array
            if let index = self.cart[0].line_items.firstIndex(where: {$0.id == lineItemID}) {
                self.cart[0].line_items[index].quantity = quantity
               // self.cart[0].line_items[index].price = totalPrice
                print(self.cart[0].line_items[index].price)
                self.CartTableView.reloadData()
                self.updateDraftOrder(lineItemsArr: self.cart[0].line_items)
            }
        }

        
    }
}
