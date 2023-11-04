//
//  LoginViewModel.swift
//  MagicaVogue
//
//  Created by Gsm on 02/11/2023.
//

import Foundation
import GoogleSignIn
import Firebase
import FirebaseAuth

class LoginViewModel{
    var iconClick = true

    var CustomersArray: [customers]?

    func getCustomer(url: String, completion: @escaping (Result<[customers], Error>) -> Void) {
        APIManager.shared.request(.get, url) { (result: Result<Customer, Error>) in
            switch result {
            case .success(let customer):
                self.CustomersArray = customer.customers
                completion(.success(self.CustomersArray ?? [])) // Return the fetched customers via completion handler

                let userDefaults = UserDefaults.standard
                userDefaults.set(self.CustomersArray?[0].id, forKey: "customerID")
                userDefaults.set(self.CustomersArray?[0].first_name, forKey: "customerName")
               
                
                userDefaults.synchronize()
                let customerID = userDefaults.integer(forKey: "customerID")

                userDefaults.set("USD", forKey: "CurrencyKey\(customerID)")
                userDefaults.set(1, forKey: "CurrencyValue\(customerID)")
                userDefaults.synchronize()

                print(customerID)
                
            case .failure(let error):
                completion(.failure(error)) // Return the error via completion handler
            }
        }
    }
    
//
//    func getCustomers(url: String) {
//        APIManager.shared.request(.get, url) { (result: Result<Customer, Error>) in
//            switch result {
//            case .success(let customer):
//                self.CustomersArray = customer.customers
//                print(self.CustomersArray)
//                
//
//            case .failure(let error):
//                print("Request failed with error: \(error)")
//            }
//        }
//    }
//    
    func getCustomerID(email : String)  {
        for i in 0..<(CustomersArray?.count ?? 0){
            let Email : String = (CustomersArray?[i].email)!
            if (email == Email){
                let userDefaults = UserDefaults.standard
                userDefaults.set(CustomersArray?[i].id, forKey: "customerID")
                userDefaults.synchronize()
                    break
            }
        }
        
    }
    
    
    func signInWithGoogle(credential: AuthCredential) async throws -> AuthDataResultModel {
        let authDataResults = try await Auth.auth().signIn(with: credential)
        return AuthDataResultModel(user: authDataResults.user)

    }
}
