//
//  ShippingDetailsVC.swift
//  MagicaVogue
//
//  Created by Heba Elcc on 22.10.2023.
//

import UIKit

class ShippingDetailsVC: UIViewController {
    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var lastName: UITextField!
    
    @IBOutlet weak var mobile: UITextField!
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var city: UITextField!
    
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var country: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    
     @IBAction func saveAddressButton(_ sender: Any) {
         
         
          let tab = TabBarController()
          self.navigationController?.setViewControllers([tab], animated: true)
     }
   

}
