//
//  PromoCodeCell.swift
//  MagicaVogue
//
//  Created by Shimaa Elcc on 22.10.2023.
//

import UIKit

class PromoCodeCell: UITableViewCell {

    @IBOutlet weak var promocodeBackgroundView: UIView!
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
    
}
