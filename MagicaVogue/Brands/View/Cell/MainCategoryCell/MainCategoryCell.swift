//
//  MainCategoryCell.swift
//  MagicaVogue
//
//  Created by Hoda Elnaghy on 10/19/23.
//

import UIKit

class MainCategoryCell: UICollectionViewCell {
    @IBOutlet weak var mainCategoryBackgroundView: UIView!
    
    @IBOutlet weak var mainCategoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainCategoryBackgroundView.layer.cornerRadius = 20
        mainCategoryBackgroundView.clipsToBounds = true
        mainCategoryBackgroundView.dropShadow()
        
        
        
    }

}
