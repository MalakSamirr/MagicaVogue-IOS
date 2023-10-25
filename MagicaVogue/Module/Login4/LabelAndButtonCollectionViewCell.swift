//
//  LabelAndButtonCollectionViewCell.swift
//  MagicaVogue
//
//  Created by Heba Elcc on 25.10.2023.
//

import UIKit

class LabelAndButtonCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var actionButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupUI(labelTitle: String, buttonTitle: String) {
        self.label.text = labelTitle
        self.actionButton.setTitle(buttonTitle, for: .normal)
    }
}
