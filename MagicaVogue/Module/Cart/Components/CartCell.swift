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
    
    var lineItemsDelegate: updateLineItemsProtocol?
    var quantity: Double = 1
    var maxQuantity: Double? = 3.0
    var inventoryItemId: Int?
    var lineItem: LineItem?
    
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
        productPriceLabel.text = lineItem.price
    }
    
    @IBAction func didPressPlus(_ sender: Any) {
        
        let price = Double(productPriceLabel.text ?? "0")
        if quantity < maxQuantity ?? 0 {
            
            let priceForItem = (price ?? 0)/Double(quantity)
            quantity += 1
            let intQuantity = Int(quantity)
            productPriceLabel.text = String(Double(quantity)*priceForItem)
            editVariantQuantity(inventory_item_id: inventoryItemId ?? 0, new_quantity: -1) {
            self.lineItemsDelegate?.updateQuantity(lineItemID: self.lineItem?.id ?? 0, quantity: intQuantity, totalPrice: self.productPriceLabel.text ?? "0")
            }
        }
}
    
    @IBAction func didPressMinus(_ sender: Any) {
        print("Minus button pressed")
        if quantity > 1 {
            let price = Double(productPriceLabel.text ?? "0")
            let priceForItem = (price ?? 0)/Double(quantity)

            quantity -= 1
            productPriceLabel.text = String(Double(quantity)*priceForItem)
            let intQuantity = Int(quantity)

            editVariantQuantity(inventory_item_id: inventoryItemId ?? 0, new_quantity: 1) {
                self.lineItemsDelegate?.updateQuantity(lineItemID: self.lineItem?.id ?? 0, quantity: intQuantity, totalPrice: self.productPriceLabel.text ?? "0")
                
            }
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
