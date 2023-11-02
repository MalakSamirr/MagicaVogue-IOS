//
//  CartViewController.swift
//  MagicaVogue
//
//  Created by Heba Elcc on 18.10.2023.
//

import UIKit
import Alamofire
import Kingfisher

class CartViewController: UIViewController , UITableViewDataSource , UITableViewDelegate {
    
    var cart: [DraftOrder] = []
    var totalPrice: Double = 0
    var customer_id : Int = 7471279866172

    @IBOutlet weak var CartTableView: UITableView!
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Cart"
        
        self.navigationController?.navigationBar.backgroundColor = .white
        CartTableView.delegate = self
        CartTableView.dataSource = self
        CartTableView.register(UINib(nibName: "CartCell", bundle: nil), forCellReuseIdentifier: "CartCell")
        getCart()
        
//        totalPrice = 0

        CartTableView.reloadData()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCart()
        print("hhhfffffffffff\(cart)")
//        totalPrice = 0
//        for item in cart {
//            let itemPrice = Double(item.line_items[0].price ?? "0") ?? 0
//            totalPrice += itemPrice
//        }
//        totalPriceLabel.text = String(totalPrice)
    }
  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !cart.isEmpty, let firstDraftOrder = cart.first {
               return firstDraftOrder.line_items.count
           } else {
               return 0
           }
    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
//        guard indexPath.row < cart[0].line_items.count else {
//               return UITableViewCell()
//           }
//        let draftOrder = cart[0].line_items[indexPath.row]
//                cell.productNameLabel.text = draftOrder.title
//
//                cell.productPriceLabel.text = draftOrder.price
//
////        if let imageUrl = URL(string: draftOrder[applied_discount.description) {
////            cell.productImageView.kf.setImage(with: imageUrl)
////        } else {
////            cell.productImageView.image = UIImage(named: "CouponBackground")
////        }
//            return cell
//    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
        
        if indexPath.row < cart[0].line_items.count {
            let draftOrder = cart[0].line_items[indexPath.row]
            cell.productNameLabel.text = draftOrder.title
            cell.productPriceLabel.text = draftOrder.price

            // Handle the image loading here (uncomment and adapt this part as needed)
            // if let imageUrl = URL(string: draftOrder.applied_discount.description) {
            //     cell.productImageView.kf.setImage(with: imageUrl)
            // } else {
            //     cell.productImageView.image = UIImage(named: "CouponBackground")
            // }
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
//        let copounsViewController = CopounsViewController()
//        let nav = UINavigationController(rootViewController: copounsViewController)
//        nav.modalPresentationStyle = .pageSheet
//
//        if let sheet = nav.sheetPresentationController {
//            sheet.detents = [.medium()]
//            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
//            sheet.largestUndimmedDetentIdentifier = .medium
//        }
//        present(nav , animated: true , completion: nil)
        let checkoutVC = CheckoutVC()

            checkoutVC.cart = self.cart
            checkoutVC.totalPrice = totalPrice

        

                // Push or present the CheckoutViewController
          navigationController?.pushViewController(checkoutVC, animated: true)
        
    }
    
    
    func getCart() {
        if APIManager.shared.isOnline() {
            APIManager.shared.request(.get, "https://9ec35bc5ffc50f6db2fd830b0fd373ac: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@ios-q1-new-capital-2023.myshopify.com/admin/api/2023-10/draft_orders.json") { [self] (result: Result<DraftOrderResponse, Error>) in
                switch result {
                case .success(let draftOrderResponse):
                    // Filter draft orders with note: "cart"
                    self.cart = draftOrderResponse.draft_orders.filter { $0.note == "cart"  && $0.customer?.id == self.customer_id  }
                    for item in cart {
                        let itemPrice = Double(item.line_items[0].price ?? "0") ?? 0
                        self.totalPrice += itemPrice
}
                    updateTotalPriceLabel()

                    DispatchQueue.main.async {
                        self.totalPriceLabel.text = String(self.totalPrice)
                        self.CartTableView.reloadData()
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
            }
        } else {
            print("Not connected")
        }
    }

    
    func deleteLineItemFromDraftOrder(draftOrderId: Int, lineItemId: Int) {
        // Your Shopify API URL
        let baseURLString = "https://ios-q1-new-capital-2023.myshopify.com/admin/api/2023-10/draft_orders/\(draftOrderId).json"
        
        let headers: HTTPHeaders = ["X-Shopify-Access-Token": "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"]
        
        // Find the index of the draft order to update
        if let draftOrderIndex = cart.firstIndex(where: { $0.id == draftOrderId }) {
            // Find the index of the line item to delete within the draft order
            if let lineItemIndex = cart[draftOrderIndex].line_items.firstIndex(where: { $0.id == lineItemId }) {
                // Remove the line item from the draft order's line_items array
                cart[draftOrderIndex].line_items.remove(at: lineItemIndex)
                
                // Create the updated draft order data
                let draftOrderData: [String: Any] = [
                    "draft_order": [
                        "line_items": cart[draftOrderIndex].line_items
                    ]
                ]
                
                // Send a PUT request to update the draft order
                AF.request(baseURLString, method: .put, parameters: draftOrderData, encoding: JSONEncoding.default, headers: headers)
                    .response { response in
                        switch response.result {
                        case .success:
                            // Successfully deleted the line item from the Draft Order
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
            let lineItemData: [String: Any] = [
                "title": lineItem.title,
                "price": lineItem.price,
                "quantity": lineItem.quantity
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
                    
                    // Append the product to the cart array
//                    self.productDetailsViewModel.cart.append(self.productDetailsViewModel.myProduct)
                    
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
