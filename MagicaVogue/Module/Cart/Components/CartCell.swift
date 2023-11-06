//
//  CartCell.swift
//  MagicaVogue
//
//  Created by Heba Elcc on 18.10.2023.
//

import UIKit
import Alamofire
class CartCell: UITableViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var productNameLabel: UILabel!
    
    @IBOutlet weak var productPriceLabel: UILabel!
    
    @IBOutlet weak var quantityLabel: UILabel!
    
    @IBOutlet weak var sizeLabel: UILabel!
    
    @IBOutlet weak var minus: UIButton!
    
    @IBOutlet weak var plus: UIButton!
    
    @IBOutlet weak var orderTotalLabel: UILabel!
    weak var viewController: UIViewController?

    var lineItemsDelegate: updateLineItemsProtocol?
    var quantity: Double = 1
    var maxQuantity: Double? = 3.0
    var inventoryItemId: Int?
    var lineItem: LineItem?
    var productPrice: Double?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        plus.layer.cornerRadius = 8
        plus.layer.borderWidth = 1
        plus.layer.borderColor = UIColor(red: 0.26, green: 0.36, blue:0.32, alpha: 1.0).cgColor
        plus.setTitle("", for: .normal)
        
        minus.layer.cornerRadius = 8
        minus.layer.borderWidth = 1
        minus.layer.borderColor = UIColor(red: 0.26, green: 0.36, blue:0.32, alpha: 1.0).cgColor
        minus.setTitle("", for: .normal)
        
        productImageView.layer.cornerRadius = 10
        productImageView.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
//        let intQuantity = Int(quantity)
//        quantityLabel.text = String(intQuantity)
        // Configure the view for the selected state
    }
    
    func setupUI(lineItem: LineItem) {
        self.lineItem = lineItem
        self.quantity = Double(lineItem.quantity)
        quantityLabel.text = String(Int(self.quantity))
        productNameLabel.text = lineItem.title
        //productPriceLabel.text = String ((Double(lineItem.price ?? "0") ?? 0)*quantity)
        
        
        if let intValue = Double(lineItem.price ?? "0"){

            let userDefaults = UserDefaults.standard

            let customerID = userDefaults.integer(forKey: "customerID")
            let CurrencyValue = userDefaults.double(forKey: "CurrencyValue\(customerID)")
            let CurrencyKey = userDefaults.string(forKey: "CurrencyKey\(customerID)")

            let result = intValue * CurrencyValue * quantity
                let resultString = String(format: "%.2f", result)
            productPriceLabel.text = resultString
            }
        
    }
    
    @IBAction func didPressPlus(_ sender: Any) {
        
        let price = Double(productPriceLabel.text ?? "0")
        if 0 < maxQuantity ?? 0 {
            
            let priceForItem = (price ?? 0)/Double(quantity)
            quantity += 1
            let intQuantity = Int(quantity)
            productPriceLabel.text = String(Double(quantity)*(productPrice ?? 0))
            editVariantQuantity(inventory_item_id: inventoryItemId ?? 0, new_quantity: -1) {
            self.lineItemsDelegate?.updateQuantity(lineItemID: self.lineItem?.id ?? 0, quantity: intQuantity, totalPrice: self.productPriceLabel.text ?? "0")
            }
        }
}
    
    @IBAction func didPressMinus(_ sender: Any) {
        if quantity > 1 {
            let price = Double(productPriceLabel.text ?? "0")
            let priceForItem = (price ?? 0)/Double(quantity)

            quantity -= 1
            productPriceLabel.text = String(Double(quantity)*(productPrice ?? 0) ?? 0)
            let intQuantity = Int(quantity)

            editVariantQuantity(inventory_item_id: inventoryItemId ?? 0, new_quantity: 1) {
                self.lineItemsDelegate?.updateQuantity(lineItemID: self.lineItem?.id ?? 0, quantity: intQuantity, totalPrice: self.productPriceLabel.text ?? "0")
                
            }
        }else{
            if let viewController = viewController {
                       showRedToast(message: "Swipe left to delete this item", on: viewController)
                   } else {
                   }
        }
    }
    
    func showRedToast(message: String, on viewController: UIViewController) {
        let toastView = ToastView2(message: message)
        toastView.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.addSubview(toastView)
        NSLayoutConstraint.activate([
            toastView.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor, constant: 16),
            toastView.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor, constant: -16),
            toastView.bottomAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])

        UIView.animate(withDuration: 5.0, animations: {
            toastView.alpha = 0
        }) { _ in
            toastView.removeFromSuperview()
        }
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
