//
//  LoginViewModel.swift
//  MagicaVogue
//
//  Created by Gsm on 02/11/2023.
//

import Foundation
class LoginViewModel{
    
    var CustomersArray: [customers]?

    func getCustomers(url: String, completion: @escaping (Result<[customers], Error>) -> Void) {
        APIManager.shared.request(.get, url) { (result: Result<Customer, Error>) in
            switch result {
            case .success(let customer):
                self.CustomersArray = customer.customers
                completion(.success(self.CustomersArray ?? [])) // Return the fetched customers via completion handler

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
    func checkCustomerInfo(email : String) -> Bool {
            var flag = false
        for i in 0..<(CustomersArray?.count ?? 0){
            let Email : String = (CustomersArray?[i].email)!
            if (email == Email){
                
                    flag = true
                  //  UserDefaultsHelper.shared.saveAPI(id: (CustomersArray.customers[i].id)!)
                    break
            }
        }
        return flag
    }
    
    
    
}
