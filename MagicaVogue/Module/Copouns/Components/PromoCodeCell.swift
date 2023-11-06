//
//  PromoCodeCell.swift
//  MagicaVogue
//
//  Created by Heba Elcc on 22.10.2023.
//

import UIKit

class PromoCodeCell: UITableViewCell {

    @IBOutlet weak var promocodeBackgroundView: UIView!
    
    @IBOutlet weak var Discount: UILabel!
    @IBOutlet weak var promoCode: UITextField!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    @IBOutlet weak var priceAfterDiscount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        promocodeBackgroundView.layer.cornerRadius = 16
        promocodeBackgroundView.clipsToBounds = true
        promocodeBackgroundView.dropShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func ApplyPromoCode(_ sender: UIButton) {
//        if let promoCodeText = promoCode.text, ["SALE", "SUMMER","20OFF"].contains(promoCodeText) {
//            Discount.text = "-10%"
//            priceAfterDiscount.text = Int(totalPriceLabel.text)*0.9
//
//        }else{
//            Discount.text = "0%"
//        }
        if let promoCodeText = promoCode.text, ["SALE", "SUMMER", "20OFF"].contains(promoCodeText) {
                Discount.text = "-20%"
                if let totalPrice = Double(totalPriceLabel.text ?? "0") {
                    let priceAfterDiscountValue = totalPrice * 0.9
                    priceAfterDiscount.text = String(format: "%.2f", priceAfterDiscountValue)
                }
            } else {
                Discount.text = "0%"
                priceAfterDiscount.text = totalPriceLabel.text
            }
    }
    
}
