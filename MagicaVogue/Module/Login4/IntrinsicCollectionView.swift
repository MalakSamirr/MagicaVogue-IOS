//
//  IntrinsicCollectionView.swift
//
//  Created by Shimaa Elcc on 25.10.2023.
//  Copyright © 2023. All rights reserved.
//

import UIKit

class IntrinsicCollectionView: UICollectionView {
    
    override var contentSize: CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()            
        }
    }
    
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return contentSize
    }
    
    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
    }
}
