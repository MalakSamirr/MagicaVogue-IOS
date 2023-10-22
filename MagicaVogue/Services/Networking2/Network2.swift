//
//  Network2.swift
//  MagicaVogue
//
//  Created by Hoda Elnaghy on 10/22/23.
//

import Foundation
import Alamofire

class ApiManger {
    
    static let SharedApiManger = ApiManger()
    
   private  init(){
        
    }
    
   
    
    func fetchData<T: Decodable>(url: String, decodingModel: T.Type, completion: @escaping (T?, Error?) -> Void) {
        AF.request(url).validate().responseDecodable(of: T.self) { response in
        
        switch response.result {
        case .success(let decodedData):
           // print("DeBug: \(response)")
            completion(decodedData, nil)
        case .failure(let error):
            completion(nil, error)
            
        }
        
    }
        
    }
    
}
