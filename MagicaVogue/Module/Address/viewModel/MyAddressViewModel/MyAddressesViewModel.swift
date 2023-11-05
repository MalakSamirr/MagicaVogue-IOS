//
//  MyAddressesViewModel.swift
//  MagicaVogue
//
//  Created by Shimaa Elcc on 4.11.2023.
//

import Foundation
import Alamofire
import RxSwift
import RxRelay

class MyAddressesViewModel {
    var addresses: [Address] = []
    var selectedAddress: Address?
    var selectedIndex: Int?
    
    var refresh: PublishRelay<Void> = PublishRelay()
    var havingError: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    var addressDeletedSuccessfully: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var defaultAddressSet: BehaviorRelay<Int?> = BehaviorRelay(value: 0)
    init() {
        if let savedIndex = UserDefaults.standard.value(forKey: "SelectedAddressIndex") as? Int,
           let selectedAddress = UserDefaults.standard.value(forKey: "SelectedAddress") as? Data,
           let decodedAddress = try? JSONDecoder().decode(Address.self, from: selectedAddress) {
            
            selectedIndex = savedIndex
            self.selectedAddress = decodedAddress
        }
    }
        func getAddresses() {
            let baseURLString = "https://ios-q1-new-capital-2023.myshopify.com/admin/api/2023-10/customers/7495027327292/addresses.json"
            let headers: HTTPHeaders = ["X-Shopify-Access-Token": "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"]
            
            AF.request(baseURLString, method: .get, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: Customer.self) { response in
                    switch response.result {
                    case .success(let customer):
                        if let addresses = customer.addresses {
                            self.addresses = addresses
                            self.refresh.accept(())
                        }
                    case .failure(let error):
                        self.havingError.accept(error.localizedDescription)
                        print("Failed to fetch addresses. Error: \(error)")
                    }
                }
        }
        func deleteAddress(_ address: Address) {
            let baseURLString = "https://ios-q1-new-capital-2023.myshopify.com/admin/api/2023-10/customers/7495027327292/addresses/\(address.id ?? 0).json"
            let headers: HTTPHeaders = ["X-Shopify-Access-Token": "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"]
            
            AF.request(baseURLString, method: .delete, headers: headers)
                .response { response in
                    switch response.result {
                    case .success:
                        // Successfully deleted the address from the server
                        
                        if response.response?.statusCode ?? 400 >= 400 {
                            self.addressDeletedSuccessfully.accept(false)
                        } else {
                            if let index = self.addresses.firstIndex(of: address) {
                                self.addresses.remove(at: index)
                                self.addressDeletedSuccessfully.accept(true)
                            }
                        }
                        
                        //                    self.showDeleteSuccessAlert()
                        
                    case .failure(let error):
                        print("Failed to delete address. Error: \(error)")
                        self.addressDeletedSuccessfully.accept(false)
                    }
                }
        }
        func setDefaultAddressForCustomer(_ address: Address, index: Int) {
            let baseURLString = "https://ios-q1-new-capital-2023.myshopify.com/admin/api/2023-10/customers/7495027327292/addresses/\(address.id ?? 0)/default.json"
            let headers: HTTPHeaders = ["X-Shopify-Access-Token": "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"]
            
            AF.request(baseURLString, method: .put, headers: headers)
                .response { response in
                    switch response.result {
                    case .success:
                        self.defaultAddressSet.accept(index)
                        print("Default address set successfully")
                    case .failure(let error):
                        print("Failed to set default address. Error: \(error)")
                    }
                }
        }
        
    }
