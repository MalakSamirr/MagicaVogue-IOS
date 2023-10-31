//
//  CurrencyCell.swift
//  MagicaVogue
//
//  Created by Gsm on 30/10/2023.
//

import UIKit

class CurrencyCell: UITableViewCell {

    @IBOutlet weak var checkMark: UIImageView!
    
    
    @IBOutlet weak var currencyLabel: UILabel!
    
    var isChecked = false
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
