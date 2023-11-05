//
//  ItemCell.swift
//  MagicaVogue
//
//  Created by Hoda Elnaghy on 10/19/23.
//

import UIKit
import Lottie
import Firebase
import FirebaseAuth
class ItemCell: UICollectionViewCell {

    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var brandItemImage: UIImageView!
    var id: Int?
    var animationDelegate: FavoriteProtocol?
    private var animationView: LottieAnimationView?
    var isFavourite: Bool?
    var draftOrder: Int?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        brandItemImage.layer.cornerRadius = 16
        brandItemImage.clipsToBounds = true

    }
    
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        if (Auth.auth().currentUser != nil) {
            if !(favoriteButton?.isSelected ?? false) {
                animationDelegate?.playAnimation()
                animationDelegate?.addToFavorite(id ?? 0)
                
            } else {
                animationDelegate?.deleteFromFavorite(id ?? 0)
                animationDelegate?.deleteFromFavorite2(draftOrder ?? 0)
            }
            favoriteButton?.isSelected = !(favoriteButton?.isSelected ?? false)
        }
    }
    
}

