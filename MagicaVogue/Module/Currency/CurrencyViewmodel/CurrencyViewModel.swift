//
//  CurrencyViewModel.swift
//  MagicaVogue
//
//  Created by Gsm on 31/10/2023.
//

import Foundation
import Alamofire

class CurrencyViewModel {
    var currencies: Currency?
    var currencies2 : Currency?
    var currencySelected : String = ""
    var changedCurrencyTo : CurrencyChange?
    

    
//    func addCurrency() {
//       let baseURLString = "https://ios-q1-new-capital-2023.myshopify.com/admin/api/2023-10/customers/7495027327292.json"
//       let headers: HTTPHeaders = ["X-Shopify-Access-Token": "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"]
//       // Request body data
//        let customerCurrency :[String:Any] = [
//            "customer": [
//                "last_name": "30.45",
//                "currency": "SAR"
//
//            ]
//
//        ]
        
//       AF.request(baseURLString, method: .put, parameters: customerCurrency, encoding: JSONEncoding.default, headers: headers)
//           .response { response in
//               switch response.result {
//               case .success:
//                   print("Currency added successfully.")
//                              case .failure(let error):
//                   print("Failed to add the address. Error: \(error)")
//              }
//           }
//    }
  
}
