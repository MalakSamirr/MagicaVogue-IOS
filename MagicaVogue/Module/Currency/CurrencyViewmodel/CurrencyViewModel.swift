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
    

    
    func changeCurrency(){
        let from = "USD"
        let to = "EGP"
        let api = "https://api.fastforex.io/fetch-one?api_key=e07402dc31-efa888e5a7-s3av7p&to=\(to)&from=\(from)"
        
        AF.request(api).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let currencyResponse = try JSONDecoder().decode(CurrencyChange.self, from: data)
                    // Handle the decoded data
                    self.changedCurrencyTo = currencyResponse
                    print(currencyResponse)
                    print(self.changedCurrencyTo?.result)
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
}
