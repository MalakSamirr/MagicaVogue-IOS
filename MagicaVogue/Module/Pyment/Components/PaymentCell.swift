//
//  PaymentCell.swift
//  MagicaVogue
//
//  Created by Heba Elcc on 20.10.2023.
//

import UIKit

class PaymentCell: UITableViewCell {

    @IBOutlet weak var payPalBackgroundView: UIView!
    @IBOutlet weak var cashBackgroundView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        payPalBackgroundView.layer.cornerRadius = 16
        payPalBackgroundView.clipsToBounds = true
        payPalBackgroundView.dropShadow()
        
        cashBackgroundView.layer.cornerRadius = 16
        cashBackgroundView.clipsToBounds = true
        cashBackgroundView.dropShadow()
        
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
