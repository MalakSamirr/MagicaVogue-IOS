//
//  PaymentTableViewCell.swift
//  MagicaVogue
//
//  Created by Shimaa Elcc on 1.11.2023.
//

import UIKit

class PaymentTableViewCell: UITableViewCell {

    @IBOutlet weak var cellImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
