//
//  ProductDetailsRequest.swift
//  intexsys-test-task
//
//  Created by Vladislav Khomyakov on 01.07.2022.
//

import Foundation
import Combine

final class ProductDetailsRequest: Requestable {
    
    private let productUrl: String
    
    var urlRequest: URLRequest {
        let apiVersion = "0.3"
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = APIConstants.host
        urlComponents.path = "/api/\(apiVersion)/products/\(productUrl)"
        
        var urlRequest = URLRequest(url: urlComponents.url!)
        urlRequest.addValue(
            APIConstants.apiKey,
            forHTTPHeaderField: APIConstants.xApiKeyHeader
        )
        
        return urlRequest
    }
    
    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return decoder
    }
    
    init(productUrl: String) {
        self.productUrl = productUrl
    }
    
    func execute(apiService: OpticsplanetAPIServicing) -> AnyPublisher<ProductDetails, Error> {
        apiService.requestData(self)
    }
}
