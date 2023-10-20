//
//  MyAddressesCell.swift
//  MagicaVogue
//
//  Created by Heba Elcc on 19.10.2023.
//

import UIKit

class MyAddressesCell: UITableViewCell {

    @IBOutlet weak var changeButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()

//
//        changeButton.layer.borderColor = UIColor.brown.cgColor
        
        changeButton.layer.borderWidth = 2.0
        changeButton.layer.borderColor = UIColor.systemBrown.cgColor
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
   

        // Configure the view for the selected state
    }
    
    @IBAction func changeButtonPrssed(_ sender: UIButton) {
//        let myAddressesVC = MyAddressesVC()
//        navigationController?.pushViewController(myAddressesVC, animated: true)
        if let navigationController = self.window?.rootViewController as? UINavigationController {
               let myAddressesVC = MyAddressesVC()
               navigationController.pushViewController(myAddressesVC, animated: true)
           }
    }
    
}
