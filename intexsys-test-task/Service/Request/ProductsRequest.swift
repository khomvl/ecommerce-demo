//
//  ProductsRequest.swift
//  intexsys-test-task
//
//  Created by Vladislav Khomyakov on 01.07.2022.
//

import Foundation
import Combine

final class ProductsRequest: Requestable {
    
    private let categoryUrl: String
    
    var urlRequest: URLRequest {
        let apiVersion = "0.3"
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = APIConstants.host
        urlComponents.path = "/iv-api/\(apiVersion)/catalog/\(categoryUrl)/products"
        urlComponents.queryItems = [
            URLQueryItem(name: "_iv_include", value: "gridProducts")
        ]
        
        var urlRequest = URLRequest(url: urlComponents.url!)
        urlRequest.addValue(
            APIConstants.apiKey,
            forHTTPHeaderField: APIConstants.xApiKeyHeader
        )
        
        return urlRequest
    }
    
    let decoder = JSONDecoder()
    
    init(categoryUrl: String) {
        self.categoryUrl = categoryUrl
    }
    
    func execute(apiService: OpticsplanetAPIServicing) -> AnyPublisher<[Product], Error> {
        apiService.requestData(self)
    }
}
