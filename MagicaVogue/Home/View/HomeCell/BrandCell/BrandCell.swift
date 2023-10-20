//
//  BrandCell.swift
//  MagicaVogue
//
//  Created by Hoda Elnaghy on 10/18/23.
//

import UIKit

class BrandCell: UICollectionViewCell {

    @IBOutlet weak var brandImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        brandImage.layer.cornerRadius = 16
        brandImage.clipsToBounds = true
    }

}
