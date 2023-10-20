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
    
    var quantity: Int = 1
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        quantityLabel.text = String(quantity)
        
        productImageView.layer.cornerRadius = 10
        productImageView.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func didPressPlus(_ sender: Any) {
        print("Plus button pressed")
        
        
        
        quantity += 1
        quantityLabel.text = String(quantity)
        print("New quantity: \(quantity)")
    }
    
    @IBAction func didPressMinus(_ sender: Any) {
        print("Minus button pressed")
        if quantity > 0 {
            quantity -= 1
            print("New quantity: \(quantity)")
        }
        quantityLabel.text = String(quantity)
    }
    
    

}
