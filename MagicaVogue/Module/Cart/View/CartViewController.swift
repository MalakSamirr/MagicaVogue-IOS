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
    
    var cart: [DraftOrder] = []
    var totalPrice: Double = 0
    @IBOutlet weak var CartTableView: UITableView!
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Cart"
        
        self.navigationController?.navigationBar.backgroundColor = .white
        CartTableView.delegate = self
        CartTableView.dataSource = self
        CartTableView.register(UINib(nibName: "CartCell", bundle: nil), forCellReuseIdentifier: "CartCell")
        
//        totalPrice = 0

        CartTableView.reloadData()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
                getCart()
            }
//        totalPrice = 0
//        for item in cart {
//            let itemPrice = Double(item.line_items[0].price ?? "0") ?? 0
//            totalPrice += itemPrice
//        }
//        totalPriceLabel.text = String(totalPrice)
    }
  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
                       
            let draftOrder = cart[indexPath.row]
            if let lineItem = draftOrder.line_items.first, !lineItem.title.isEmpty {
                cell.productNameLabel.text = lineItem.title
                
                cell.productPriceLabel.text = lineItem.price


            } else {
                cell.productNameLabel.text = "Product Name Not Available"
            }
        if let imageUrl = URL(string: draftOrder.applied_discount.description) {
            cell.productImageView.kf.setImage(with: imageUrl)
        } else {
            cell.productImageView.image = UIImage(named: "CouponBackground")
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
                // Get the draft order ID to delete
                let draftOrderId = self?.cart[indexPath.row].id
                
                if let draftOrderId = draftOrderId {
                    self?.deleteDraftOrder(draftOrderId: draftOrderId)
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
                    self.cart = draftOrderResponse.draft_orders.filter { $0.note == "cart" }
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

    
    func deleteDraftOrder(draftOrderId: Int) {
        // Your Shopify API URL
        let baseURLString = "https://ios-q1-new-capital-2023.myshopify.com/admin/api/2023-10/draft_orders/\(draftOrderId).json"
        
        let headers: HTTPHeaders = ["X-Shopify-Access-Token": "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"]
        
        AF.request(baseURLString, method: .delete, headers: headers)
            .response { response in
                switch response.result {
                case .success:
                    // Successfully deleted the Draft Order
                    print("Draft Order with ID \(draftOrderId) deleted successfully.")
                    
                    // Update the local data source (remove the deleted item)
                    if let index = self.cart.firstIndex(where: { $0.id == draftOrderId }) {
                        self.cart.remove(at: index)
                    }
                    self.updateTotalPriceLabel()

                    DispatchQueue.main.async {
                        self.CartTableView.reloadData()
                    }
                case .failure(let error):
                    print("Failed to delete Draft Order with ID \(draftOrderId). Error: \(error)")
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


}
