//
//  APIManager.swift
//  MagicaVogue
//
//  Created by Heba Elcc on 23.10.2023.
//

import Foundation
import Alamofire

class APIManager {
    static let shared = APIManager()
    
    private init(){}
    
    func request<T: Codable>(
        _ method: HTTPMethod,
        _ url: String,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        completionHandler: @escaping (Result<T, Error>) -> Void
    ){
        AF.request(url, method: method, parameters: parameters, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let data = response.data {
                        do {
                            let decoder = JSONDecoder()
                            let apiResponse = try decoder.decode(T.self, from: data)
                            completionHandler(.success(apiResponse))
                        } catch {
                            completionHandler(.failure(error))
                        }
                    }
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
    }
}
