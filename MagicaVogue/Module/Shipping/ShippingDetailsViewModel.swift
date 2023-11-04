//
//  ShippingDetailsViewModel.swift
//  MagicaVogue
//
//  Created by Shimaa Elcc on 5.11.2023.
//

import Foundation
import RxSwift
import RxRelay
import Alamofire

class ShippingDetailsViewModel {
    var addressAddeddSuccessfully: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    func addAddress(address1: String?, address2: String?, city: String?, phone: String?) {
        let baseURLString = "https://ios-q1-new-capital-2023.myshopify.com/admin/api/2023-10/customers/7495027327292/addresses.json"
        let headers: HTTPHeaders = ["X-Shopify-Access-Token": "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"]
        
        let addressData: [String: Any] = [
            "address": [
                "address1": address1 ?? "",
                "address2": address2 ?? "",//country
                "city": city ?? "",
                "company": "Fancy Co.",
                "phone": phone ?? "",
                "province": "Quebec",
                "country": "Canda",
                "zip": "G1R 4P5",
                "name": "Samuel de Champlain",
                "province_code": "QC",
                "country_code": "CA",
                "country_name": "Egypt",
                "default": true
            ]
        ]
        
        AF.request(baseURLString, method: .post, parameters: addressData, encoding: JSONEncoding.default, headers: headers)
            .response { response in
                switch response.result {
                case .success:
                    self.addressAddeddSuccessfully.accept(true)
//                    if let data = response.data {
//                        do {
//                            let newAddress = try JSONDecoder().decode(Address.self, from: data)
//                            self.addressAddeddSuccessfully.accept(true)
//                            print("Address added successfully")
                            
                            // Notify the delegate about the new address
//                        } catch {
//                            self.addressAddeddSuccessfully.accept(false)
//                            print("Failed to decode the address. Error: \(error)")
//                        }
//                    }
                case .failure(let error):
                    self.addressAddeddSuccessfully.accept(false)
                    print("Failed to add the address. Error: \(error)")
                }
            }
    }
}
