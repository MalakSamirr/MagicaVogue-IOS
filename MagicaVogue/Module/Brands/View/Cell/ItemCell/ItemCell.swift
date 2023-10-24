//
//  ItemCell.swift
//  MagicaVogue
//
//  Created by Hoda Elnaghy on 10/19/23.
//

import UIKit
import Lottie
class ItemCell: UICollectionViewCell {

    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var brandItemImage: UIImageView!
    
    var animationDelegate: FavoriteProtocol?
    private var animationView: LottieAnimationView?
    var isFavourite: Bool?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        brandItemImage.layer.cornerRadius = 16
        brandItemImage.clipsToBounds = true
        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)

    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        if !isSelected {
            animationDelegate?.playAnimation()

        }
        isSelected.toggle() // Toggle the isSelected property
            
        favoriteButton.isSelected = isSelected
    }
    
}
