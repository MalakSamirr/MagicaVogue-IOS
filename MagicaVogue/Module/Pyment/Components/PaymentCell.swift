//
//  PaymentCell.swift
//  MagicaVogue
//
//  Created by Heba Elcc on 20.10.2023.
//

import UIKit

class PaymentCell: UITableViewCell {
    @IBOutlet weak var payementTypeLabel: UILabel!
    
    @IBOutlet weak var payementImage: UIImageView!
    @IBOutlet weak var cashBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
        cashBackgroundView.layer.cornerRadius = 16
        cashBackgroundView.clipsToBounds = true
        cashBackgroundView.dropShadow()
        
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
