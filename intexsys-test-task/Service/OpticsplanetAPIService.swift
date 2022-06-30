//
//  OpticsplanetAPIService.swift
//  intexsys-test-task
//
//  Created by Vladislav Khomyakov on 30.06.2022.
//

import Foundation
import Combine

protocol OpticsplanetAPIServicing {
    func getCategories() -> AnyPublisher<[ProductCategory], Error>
    func getProducts(by categoryUrl: String) -> AnyPublisher<[Product], Error>
    func getProductDetails(productUrl: String) -> AnyPublisher<ProductDetails, Error>
}

final class OpticsplanetAPIService: OpticsplanetAPIServicing, ImageDownloading {
    
    enum Constants {
        static let host = "www.opticsplanet.com"
        static let apiKey = "9dd0a2f3998a11a9d73788d0ded95dc7c7c1ef2f3176b581a4dd300ee8eb0ae8eefe5d7f766f7f72bf0735b474ceef764279f648552fa13ce8c15043723e4e58"
        static let xApiKeyHeader = "x-apikey"
    }
    
    private let urlSession: URLSession
    
    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }
    
    func getCategories() ->  AnyPublisher<[ProductCategory], Error> {
        let apiVersion = "0.2"
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = Constants.host
        urlComponents.path = "/api/\(apiVersion)/categories"
        
        var urlRequest = URLRequest(url: urlComponents.url!)
        urlRequest.addValue(Constants.apiKey, forHTTPHeaderField: "x-apikey")
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return urlSession.dataTaskPublisher(for: urlRequest)
            .tryMap {
                guard
                    let httpResponse = $0.response as? HTTPURLResponse,
                    httpResponse.statusCode == 200
                else {
                    throw URLError(.badServerResponse)
                }
                
                guard $0.data.count > 0 else {
                    throw URLError(.zeroByteResource)
                }
                
                return $0.data
            }
            .decode(type: [ProductCategory].self, decoder: decoder)
            .share()
            .eraseToAnyPublisher()
    }
    
    func getProducts(by categoryUrl: String) -> AnyPublisher<[Product], Error> {
        let apiVersion = "0.3"
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = Constants.host
        urlComponents.path = "/iv-api/\(apiVersion)/catalog/\(categoryUrl)/products"
        urlComponents.queryItems = [
            URLQueryItem(name: "_iv_include", value: "gridProducts")
        ]
        
        var urlRequest = URLRequest(url: urlComponents.url!)
        urlRequest.addValue(Constants.apiKey, forHTTPHeaderField: Constants.xApiKeyHeader)
        
        return urlSession.dataTaskPublisher(for: urlRequest)
            .tryMap {
                guard
                    let httpResponse = $0.response as? HTTPURLResponse,
                    httpResponse.statusCode == 200
                else {
                    throw URLError(.badServerResponse)
                }
                
                guard $0.data.count > 0 else {
                    throw URLError(.zeroByteResource)
                }
                
                return $0.data
            }
            .receive(on: DispatchQueue.main)
            .decode(type: [Product].self, decoder: JSONDecoder())
            .share()
            .eraseToAnyPublisher()
    }
    
    
    func getProductDetails(productUrl: String) -> AnyPublisher<ProductDetails, Error> {
        let apiVersion = "0.3"
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = Constants.host
        urlComponents.path = "/api/\(apiVersion)/products/\(productUrl)"
        
        var urlRequest = URLRequest(url: urlComponents.url!)
        urlRequest.addValue(Constants.apiKey, forHTTPHeaderField: Constants.xApiKeyHeader)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return urlSession.dataTaskPublisher(for: urlRequest)
            .tryMap {
                guard
                    let httpResponse = $0.response as? HTTPURLResponse,
                    httpResponse.statusCode == 200
                else {
                    throw URLError(.badServerResponse)
                }
                
                guard $0.data.count > 0 else {
                    throw URLError(.zeroByteResource)
                }
                
                return $0.data
            }
            .decode(type: ProductDetails.self, decoder: decoder)
            .share()
            .eraseToAnyPublisher()
    }
    
    func getImage(imageUrl: String, size: ImageSize) -> AnyPublisher<Data, Error> {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "images1.opticsplanet.com"
        urlComponents.path = "/\(size.urlPath)/\(imageUrl).jpg"
        
        var urlRequest = URLRequest(url: urlComponents.url!)
        urlRequest.addValue(Constants.apiKey, forHTTPHeaderField: Constants.xApiKeyHeader)
        
        return urlSession.dataTaskPublisher(for: urlRequest)
            .tryMap {
                guard
                    let httpResponse = $0.response as? HTTPURLResponse,
                    httpResponse.statusCode == 200
                else {
                    throw URLError(.badServerResponse)
                }
                
                guard $0.data.count > 0 else {
                    throw URLError(.zeroByteResource)
                }
                
                return $0.data
            }
            .share()
            .eraseToAnyPublisher()
    }
}
