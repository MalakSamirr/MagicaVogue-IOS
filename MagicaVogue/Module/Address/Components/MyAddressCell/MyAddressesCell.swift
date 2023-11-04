//
//  MyAddressesCell.swift
//  MagicaVogue
//
//  Created by Heba Elcc on 19.10.2023.
//

import UIKit

class MyAddressesCell: UITableViewCell {
    var addressDelegate: AddressProtocol?

    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var myAdressBackgrounView: UIView!
    @IBOutlet weak var changeButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()

//
//        changeButton.layer.borderColor = UIColor.brown.cgColor
        
        myAdressBackgrounView.layer.cornerRadius = 16
        myAdressBackgrounView.clipsToBounds = true
        myAdressBackgrounView.dropShadow()
        
        changeButton.layer.shadowColor = UIColor.black.cgColor // Shadow color
            changeButton.layer.shadowOpacity = 0.2 // Shadow opacity
            changeButton.layer.shadowOffset = CGSize(width: 0, height: 4) // Shadow offset (adjust as needed)
            changeButton.layer.shadowRadius = 2 // Shadow radius (adjust as needed)
            
            // Optionally, you can also set a corner radius for the button to make it rounded
            changeButton.layer.cornerRadius = 8
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
   

        // Configure the view for the selected state
    }
    
    @IBAction func changeButtonPrssed(_ sender: UIButton) {
        
        addressDelegate?.NavigateToAddress()
//        let myAddressesVC = MyAddressesVC()
//        navigationController?.pushViewController(myAddressesVC, animated: true)
//        if let navigationController = self.window?.rootViewController as? UINavigationController {
//               let myAddressesVC = MyAddressesVC()
//               navigationController.pushViewController(myAddressesVC, animated: true)
//           }
  }
    
}
