//
//  SignupViewModel.swift
//  MagicaVogue
//
//  Created by Malak Samir on 24/10/2023.
//

import Foundation
import GoogleSignIn
import Alamofire

class SignupViewModel{
    
    
    var iconClick1 = true
    var iconClick2 = true
    
    func createCustomer(userFirstName: String, userLastName: String, userPassword: String, userEmail: String, userPhoneNumber: String, completion: @escaping (Result<Void, Error>) -> Void) {
           let url = "https://ios-q1-new-capital-2023.myshopify.com/admin/api/2023-10/customers.json"
           
           let headers: HTTPHeaders = ["X-Shopify-Access-Token": "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"]
           
           let parameters: [String: Any] = [
               "customer": [
                   "first_name": userFirstName,
                   "last_name": userLastName,
                   "tags": userPassword,
                   "phone": userPhoneNumber,
                   "email": userEmail,
                   "country": "CA"
               ]
           ]
           
           AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).response { response in
               switch response.result {
               case .success:
                   if let statusCode = response.response?.statusCode, statusCode == 201 {
                       // HTTP Status Code 201 indicates success (Created)
                       print("Customer created successfully")
                       completion(.success(()))
                   } else {
                       print("Unexpected HTTP status code: \(response.response?.statusCode ?? -1)")
                       completion(.failure(NSError(domain: "YourAppErrorDomain", code: -1, userInfo: nil)))
                   }
               case .failure(let error):
                   print("Error: \(error.localizedDescription)")
                   completion(.failure(error))
               }
           }
       }
}
