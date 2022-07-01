//
//  OpticsplanetAPIService.swift
//  intexsys-test-task
//
//  Created by Vladislav Khomyakov on 30.06.2022.
//

import Foundation
import Combine

enum APIConstants {
    static let host = "www.opticsplanet.com"
    static let apiKey = "9dd0a2f3998a11a9d73788d0ded95dc7c7c1ef2f3176b581a4dd300ee8eb0ae8eefe5d7f766f7f72bf0735b474ceef764279f648552fa13ce8c15043723e4e58"
    static let xApiKeyHeader = "x-apikey"
}

protocol OpticsplanetAPIServicing {
    func requestData<Req: Requestable, Res: Decodable>(_ request: Req) -> AnyPublisher<Res, Error>
}

final class OpticsplanetAPIService: OpticsplanetAPIServicing {
    
    private let urlSession: URLSession
    
    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }
    
    func requestData<Req: Requestable, Res: Decodable>(_ request: Req) -> AnyPublisher<Res, Error> {
        urlSession.dataTaskPublisher(for: request.urlRequest)
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
            .decode(type: Res.self, decoder: request.decoder)
            .share()
            .eraseToAnyPublisher()
    }
}
