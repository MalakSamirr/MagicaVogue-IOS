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
    
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                mainCategoryLabel.textColor = .white
                mainCategoryBackgroundView.backgroundColor = UIColor(red: 0.36, green: 0.46, blue: 0.42, alpha: 1.0)
            } else {
               
               mainCategoryLabel.textColor = .black
                mainCategoryBackgroundView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
            }
        }
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainCategoryBackgroundView.layer.cornerRadius = 20
        mainCategoryBackgroundView.clipsToBounds = true
        mainCategoryBackgroundView.dropShadow()
        
        func o() {
            
        }
        
    }
}
