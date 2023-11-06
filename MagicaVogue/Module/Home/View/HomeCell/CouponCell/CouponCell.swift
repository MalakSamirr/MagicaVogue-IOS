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
            showToast(message: "Copied 🎉")
            }
    }
    func showToast(message: String) {
        let toastLabel = UILabel()
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        
        // Calculate the toast frame and position it in the center of the screen
        let toastWidth: CGFloat = 200
        let toastHeight: CGFloat = 40
        let toastX = (UIScreen.main.bounds.size.width - toastWidth) / 2
        let toastY = (UIScreen.main.bounds.size.height - toastHeight) / 2
        toastLabel.frame = CGRect(x: toastX, y: toastY, width: toastWidth, height: toastHeight)
        
        UIApplication.shared.keyWindow?.addSubview(toastLabel)
        
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { _ in
            toastLabel.removeFromSuperview()
        })
    }

  




    
}
