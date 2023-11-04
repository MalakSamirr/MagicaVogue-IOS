//
//  NewAddressCell.swift
//  MagicaVogue
//
//  Created by Shimaa Elcc on 19.10.2023.
//

import UIKit

class NewAddressCell: UITableViewCell {

    @IBOutlet weak var CityAndCountryLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
