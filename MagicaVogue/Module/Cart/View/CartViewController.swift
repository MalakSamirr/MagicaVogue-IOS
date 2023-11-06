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
import RxCocoa
import RxSwift

class CartViewController: UIViewController , UITableViewDataSource , UITableViewDelegate {
    let viewModel : CartViewModel = CartViewModel()
    let disposeBag = DisposeBag()

    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var emptyCartImage: UIImageView!
    
    @IBOutlet weak var checkoutButton: UIButton!
   
    @IBOutlet weak var CartTableView: UITableView!
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Cart"
        
        self.navigationController?.navigationBar.backgroundColor = .white
        CartTableView.delegate = self
        CartTableView.dataSource = self
        CartTableView.register(UINib(nibName: "CartCell", bundle: nil), forCellReuseIdentifier: "CartCell")
        setupBindings()


    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emptyCartImage.isHidden = true

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

                viewModel.customer_id = 7471279866172
                viewModel.getCart {_ in
                    self.CartTableView.reloadData()
                  
                }
            }
    }
    func setupBindings() {
        viewModel.refresh
            .bind { [weak self] _ in
                DispatchQueue.main.async {[weak self] in
                    self?.CartTableView.reloadData()
                    self?.checkCartItems()
                    
                    self?.updateTotalPriceLabel()
                    self?.totalPriceLabel.text = String(self?.viewModel.totalPrice ?? 0)
                    
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.havingError.skip(1)
            .bind { [weak self] error in
                DispatchQueue.main.async {[weak self] in
                    self?.showToast(message: error ?? "error")
                }
            }
            .disposed(by: disposeBag)
    }
    func checkCartItems() {
        
        if viewModel.cart.isEmpty {
               
            emptyCartImage.isHidden = false
            CartTableView.isHidden = true
            checkoutButton.isHidden = true
            totalPriceLabel.isHidden = true
            totalLabel.isHidden = true

        } else {
            
            emptyCartImage.isHidden = true
            CartTableView.isHidden = false
            checkoutButton.isHidden = false
            totalPriceLabel.isHidden = false
            totalLabel.isHidden = false
            
        

           }
       }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !viewModel.cart.isEmpty, let firstDraftOrder = viewModel.cart.first {
               return firstDraftOrder.line_items.count
           } else {
               return 0
           }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
        cell.lineItemsDelegate = self
        if indexPath.row < viewModel.cart[0].line_items.count {
            let draftOrder = viewModel.cart[0].line_items[indexPath.row]
            cell.productNameLabel.text = draftOrder.title
            cell.setupUI(lineItem: draftOrder)
            cell.productPrice = Double(draftOrder.price ?? "0")
            let targetProductId = viewModel.cart[0].line_items[indexPath.row].product_id
            if let filteredProduct = viewModel.productDataArray.first(where: { $0.product.id == targetProductId }) {
                let imageUrlString = filteredProduct.product.image?.src
                if let imageUrl = URL(string: imageUrlString ?? "") {
                    cell.productImageView.kf.setImage(with: imageUrl)
                }
                if let filteredVariant = filteredProduct.product.variants?.first(where: {
                    $0.id == viewModel.cart[0].line_items[indexPath.row].variant_id
                }) {
                    cell.maxQuantity = Double(filteredVariant.inventory_quantity)
                    cell.inventoryItemId = filteredVariant.inventory_item_id
                    cell.sizeLabel.text = "Details: \(filteredVariant.title ?? "")"
                }
            } else {

            }
            if indexPath.row == 0 {
                viewModel.price = Double(cell.productPriceLabel.text ?? "0") ?? 0
            } else {
                if let cellPrice = Double(cell.productPriceLabel.text ?? "0") {
                    viewModel.price = (viewModel.price ?? 0.0) + cellPrice
                }
            }

            if indexPath.row == viewModel.cart[0].line_items.count - 1 {
                if let totalPrice = viewModel.price {
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
                if let draftOrderId = self?.viewModel.cart[0].id,
                   let lineItemId = self?.viewModel.cart[0].line_items[indexPath.row].id {
                    
                    
                    
                    
                    
                    
                    
                    self?.viewModel.deleteLineItemFromDraftOrder(draftOrderId: draftOrderId, lineItemId: lineItemId)
                    self?.updateDraftOrder(lineItemsArr: (self?.viewModel.cart[0].line_items)!)
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
        checkoutVC.cart = self.viewModel.cart
        checkoutVC.productDataArray = self.viewModel.productDataArray
        checkoutVC.totalPrice = viewModel.price ?? 0
          navigationController?.pushViewController(checkoutVC, animated: true)
        
    }
    
    

    func updateTotalPriceLabel() {
            // Calculate the total price based on the items in the cart
        viewModel.totalPrice = viewModel.cart.reduce(0) { (total, draftOrder) in
                if let itemPrice = Double(draftOrder.line_items.first?.price ?? "0") {
                    return total + itemPrice
                }
                return total
            }
        totalPriceLabel.text = "\(viewModel.totalPrice)"
        }
    func updateDraftOrder(lineItemsArr : [LineItem]) {
        
        var lineItems: [[String: Any]] = []

        for lineItem in lineItemsArr ?? [] {
            let lineItemData: [String: Any] = [
                "title": lineItem.title,
                "price": lineItem.price,
                "quantity": lineItem.quantity,
                "variant_id": lineItem.variant_id,
                "product_id": lineItem.product_id
            ]
            lineItems.append(lineItemData)
            
            
        }
        

        edit(lineItem: lineItems)
        
        // Now you can use the 'lineItems' array in your PUT request.
        // Call the updateDraftOrder function with the 'lineItems' array to update the draft order.
    }
    func edit(lineItem : [[String: Any]]) {
        let baseURLString = "https://ios-q1-new-capital-2023.myshopify.com/admin/api/2023-10/draft_orders/\(viewModel.cart[0].id).json"
                
        
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
//                    self.showSuccessAlert()
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
    }
    
}

extension CartViewController {
        }

    
   

    


protocol updateLineItemsProtocol {
    func edit(lineItem : [[String: Any]])
    func updateQuantity(lineItemID: Int, quantity: Int, totalPrice: String)
}

extension CartViewController: updateLineItemsProtocol {
    func updateQuantity(lineItemID: Int, quantity: Int, totalPrice: String) {
        DispatchQueue.main.async {
            // update array
            if let index = self.viewModel.cart[0].line_items.firstIndex(where: {$0.id == lineItemID}) {
                self.viewModel.cart[0].line_items[index].quantity = quantity
               // self.cart[0].line_items[index].price = totalPrice
                print(self.viewModel.cart[0].line_items[index].price)
                self.CartTableView.reloadData()
                self.updateDraftOrder(lineItemsArr: self.viewModel.cart[0].line_items)
            }
        }

        
    }
    
}
