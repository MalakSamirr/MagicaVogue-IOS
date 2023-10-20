//
//  UIView + dropShadow.swift
//  MagicaVogue
//
//  Created by Hoda Elnaghy on 10/18/23.
//

import UIKit

extension UIView {
    
    // MARK: - Drop Shadow Extension
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = .zero
        layer.shadowRadius = 2.5
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
