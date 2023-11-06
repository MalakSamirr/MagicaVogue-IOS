//
//  CurrencyViewModel.swift
//  MagicaVogue
//
//  Created by Gsm on 31/10/2023.
//

import Foundation
import Alamofire
import RxSwift
import RxRelay

class CurrencyViewModel {
    var currencies: Currency?
    var currencies2 : Currency?
    var currencySelected : String = ""
    var changedCurrencyTo : CurrencyChange?
    var refresh: PublishRelay<Void> = PublishRelay()
    var havingError: BehaviorRelay<String?> = BehaviorRelay(value: nil)

    func fetchCurrencies() {
        let apiKey = "37cbe6b58f-f82cc2e6c5-s3p2k3"
        let apiUrl = "https://api.fastforex.io/fetch-all?api_key=\(apiKey)"
        AF.request(apiUrl).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let currencyResponse = try JSONDecoder().decode(Currency.self, from: data)
                    // Handle the decoded data
                    self.currencies = currencyResponse
                    self.currencies2 = currencyResponse
                    self.refresh.accept(())

                } catch {
                    self.havingError.accept("Request failed with error: \(error.localizedDescription)")
                }
            case .failure(let error):
                self.havingError.accept("Request failed with error: \(error.localizedDescription)")
            }
        }
    }
    
    func changeCurrency(to : String){
        let from = "USD"
        let api = "https://api.fastforex.io/fetch-one?api_key=37cbe6b58f-f82cc2e6c5-s3p2k3&to=\(to)&from=\(from)"
        
        AF.request(api).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let currencyResponse = try JSONDecoder().decode(CurrencyChange.self, from: data)
                    // Handle the decoded data
                    self.changedCurrencyTo = currencyResponse
                    print(currencyResponse)
                    let value = self.changedCurrencyTo?.result?.first?.value
                    let key = self.changedCurrencyTo?.result?.first?.key
                      
              
                    GlobalData.shared.num = value ?? 0
                    GlobalData.shared.country = key ?? " "
                    
                    
                    let userDefaults = UserDefaults.standard
                    let customerID = userDefaults.integer(forKey: "customerID")

                    userDefaults.set(key, forKey: "CurrencyKey\(customerID)")
                    userDefaults.set(value, forKey: "CurrencyValue\(customerID)")

                    
                    userDefaults.synchronize()
                    print(customerID)
                    

                } catch {
                    self.havingError.accept("Request failed with error: \(error.localizedDescription)")
                }
            case .failure(let error):
                self.havingError.accept("Request failed with error: \(error.localizedDescription)")
            }
        }
    }
  
}
