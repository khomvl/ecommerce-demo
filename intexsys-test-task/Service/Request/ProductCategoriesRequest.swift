//
//  ProductCategoriesRequest.swift
//  intexsys-test-task
//
//  Created by Vladislav Khomyakov on 01.07.2022.
//

import Foundation
import Combine

final class ProductCategoriesRequest: Requestable {
    
    var urlRequest: URLRequest {
        let apiVersion = "0.2"
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = APIConstants.host
        urlComponents.path = "/api/\(apiVersion)/categories"
        
        var urlRequest = URLRequest(url: urlComponents.url!)
        urlRequest.addValue(
            APIConstants.apiKey,
            forHTTPHeaderField: "x-apikey"
        )
        
        return urlRequest
    }
    
    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return decoder
    }
    
    func execute(apiService: OpticsplanetAPIServicing) -> AnyPublisher<[ProductCategory], Error> {
        apiService.requestData(self)
    }
}
