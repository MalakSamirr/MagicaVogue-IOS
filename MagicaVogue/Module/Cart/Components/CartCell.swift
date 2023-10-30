//
//  CartCell.swift
//  MagicaVogue
//
//  Created by Heba Elcc on 18.10.2023.
//

import UIKit

class CartCell: UITableViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var productNameLabel: UILabel!
    
    @IBOutlet weak var productPriceLabel: UILabel!
    
    @IBOutlet weak var quantityLabel: UILabel!
    
    @IBOutlet weak var sizeLabel: UILabel!
    
    @IBOutlet weak var minus: UIButton!
    
    @IBOutlet weak var plus: UIButton!
    
    @IBOutlet weak var orderTotalLabel: UILabel!
    
    var quantity: Double = 1.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        quantityLabel.text = String(quantity)
        
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
        
        let intQuantity = Int(quantity)
        quantityLabel.text = String(intQuantity)
        // Configure the view for the selected state
    }
    
    @IBAction func didPressPlus(_ sender: Any) {
        
        let price = Double(productPriceLabel.text ?? "0")
                
                let priceForItem = (price ?? 0)/quantity
                quantity += 1
                productPriceLabel.text = String(quantity*priceForItem)
        
                let intQuantity = Int(quantity)
                quantityLabel.text = String(intQuantity)
                print("New quantity: \(quantity)")
    }
    
    @IBAction func didPressMinus(_ sender: Any) {
        print("Minus button pressed")
                if quantity > 1 {
                    let price = Double(productPriceLabel.text ?? "0")
                    
                    let priceForItem = (price ?? 0)/quantity
                    
                    quantity -= 1
                    productPriceLabel.text = String(quantity*priceForItem)
                    print("New quantity: \(quantity)")
                    
                    
                    
                    
                }
                
                
        let intQuantity = Int(quantity)
        quantityLabel.text = String(intQuantity)
    }
   
    
    

}
