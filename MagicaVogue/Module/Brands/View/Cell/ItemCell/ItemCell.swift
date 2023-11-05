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
            }
            favoriteButton?.isSelected = !(favoriteButton?.isSelected ?? false)
        }
//        else{
//            let alert = UIAlertController(title: "Can't add to favorite!", message: "you cannot add to favorite , Create an account first and try again!", preferredStyle: .alert)
//            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//            alert.addAction(okAction)
//            present(alert, animated: true, completion: nil)
//        }
    }
    
}

