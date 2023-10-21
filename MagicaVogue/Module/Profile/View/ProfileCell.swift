//
//  ProfileCell.swift
//  MagicaVogue
//
//  Created by Malak Samir on 19/10/2023.
//

import UIKit

class ProfileCell: UITableViewCell {

    @IBOutlet weak var profileCellBackgroundView: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileCellBackgroundView.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
