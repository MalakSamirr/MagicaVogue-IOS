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
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
               subCategoryBackgroundView.layer.borderWidth = 1.0 // Adjust the border width as needed
                subCategoryBackgroundView.layer.borderColor = UIColor(red: 0.36, green: 0.46, blue:0.42, alpha: 1.0).cgColor
            } else {
               
                subCategoryBackgroundView.layer.borderWidth = 0 // Adjust the border width as needed
                subCategoryBackgroundView.layer.borderColor = UIColor(red: 1, green: 1, blue:1, alpha: 1.0).cgColor

                 
            }
        }
        
    }
    

}
