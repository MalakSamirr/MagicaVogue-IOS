//
//  SubCategoryCell.swift
//  MagicaVogue
//
//  Created by Hoda Elnaghy on 10/19/23.
//

import UIKit

class SubCategoryCell: UICollectionViewCell {
    @IBOutlet weak var subCategoryBackgroundView: UIView!
    
    @IBOutlet weak var subCategoryItemImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        subCategoryBackgroundView.layer.cornerRadius = 30
        
        
        subCategoryBackgroundView.layer.masksToBounds = true
       // subCategoryBackgroundView.dropShadow()
    }
    

}
