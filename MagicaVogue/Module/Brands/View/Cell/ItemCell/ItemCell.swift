//
//  ItemCell.swift
//  MagicaVogue
//
//  Created by Hoda Elnaghy on 10/19/23.
//

import UIKit

class ItemCell: UICollectionViewCell {

    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var brandItemImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        brandItemImage.layer.cornerRadius = 16
        brandItemImage.clipsToBounds = true
    }

}
