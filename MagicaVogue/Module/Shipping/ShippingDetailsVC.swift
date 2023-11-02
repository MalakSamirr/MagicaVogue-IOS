//
//  ShippingDetailsVC.swift
//  MagicaVogue
//
//  Created by Heba Elcc on 22.10.2023.
//

import UIKit
import Alamofire

class ShippingDetailsVC: UIViewController {
   
    
    @IBOutlet weak var cityTextfield: UITextField!
    
    @IBOutlet weak var countryTextfield: UITextField!
    
    @IBOutlet weak var addressTextfield: UITextField!
    
    
    
    @IBOutlet weak var phoneTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func addAddress() {
       let baseURLString = "https://ios-q1-new-capital-2023.myshopify.com/admin/api/2023-10/customers/7495027327292/addresses.json"
       let headers: HTTPHeaders = ["X-Shopify-Access-Token": "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"]
       // Request body data
       let addressData: [String: Any] = [
           "address": [
            "address1": addressTextfield.text ,
                            "address2": "Suite 1234",
            "city": cityTextfield.text,
                            "company": "Fancy Co.",
            
            "phone": phoneTextfield.text,
                            "province": "Quebec",
            "country": countryTextfield.text,
                            "zip": "G1R 4P5",
                            "name": "Samuel de Champlain",
                            "province_code": "QC",
                            "country_code": "CA",
                            "country_name": "Egypt",
               "default": true
           ]
       ]
//        "address1": "1 Rue",
//                "address2": "Suite 1234",
//                "city": "Montreal",
//                "company": "Fancy Co.",
//
//                "phone": "819-555-5555",
//                "province": "Quebec",
//                "country": "Canada",
//                "zip": "G1R 4P5",
//                "name": "Samuel de Champlain",
//                "province_code": "QC",
//                "country_code": "CA",
//                "country_name": "Canada"
       AF.request(baseURLString, method: .post, parameters: addressData, encoding: JSONEncoding.default, headers: headers)
           .response { response in
               switch response.result {
               case .success:
                   print("Address added successfully.")
                              case .failure(let error):
                   print("Failed to add the address. Error: \(error)")
              }
           }
    }
    
     @IBAction func saveAddressButton(_ sender: Any) {
         addAddress()
         
          let tab = TabBarController()
          self.navigationController?.setViewControllers([tab], animated: true)
     }
   

}
