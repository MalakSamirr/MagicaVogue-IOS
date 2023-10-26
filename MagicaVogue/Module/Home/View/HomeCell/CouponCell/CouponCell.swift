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
    @IBOutlet weak var codeButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        couponImage.layer.cornerRadius = 16
        couponImage.clipsToBounds = true
        couponUIView.layer.cornerRadius = 16
        couponUIView.clipsToBounds = true
        couponUIView.dropShadow()
    }
    
    func setupUI(discountCode: DiscountCode) {
        codeButton.setTitle(discountCode.code, for: .normal)
    }

    @IBAction func copyCopounButtonPressed(_ sender: UIButton) {
        if let buttonText = sender.titleLabel?.text {
                UIPasteboard.general.string = buttonText
            }
    }
    
}
