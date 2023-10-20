//
//  CouponCell.swift
//  MagicaVogue
//
//  Created by Hoda Elnaghy on 10/18/23.
//

import UIKit

class CouponCell: UICollectionViewCell {

    @IBOutlet weak var couponUIView: UIView!
    @IBOutlet weak var couponImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        couponImage.layer.cornerRadius = 16
        couponImage.clipsToBounds = true
        couponUIView.layer.cornerRadius = 16
        couponUIView.clipsToBounds = true
        couponUIView.dropShadow()
    }

}
