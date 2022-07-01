//
//  ImageRequest.swift
//  intexsys-test-task
//
//  Created by Vladislav Khomyakov on 01.07.2022.
//

import Foundation
import Combine

final class ImageRequest: Requestable {
    
    enum ImageSize {
        case small
        case large
        
        var urlPath: String {
            switch self {
            case .small:
                return "120-90-ffffff"
            case .large:
                return "365-240-ffffff"
            }
        }
    }
    
    private let imageUrl: String
    private let imageSize: ImageSize
    
    var urlRequest: URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "images1.opticsplanet.com"
        urlComponents.path = "/\(imageSize.urlPath)/\(imageUrl).jpg"
        
        var urlRequest = URLRequest(url: urlComponents.url!)
        urlRequest.addValue(
            APIConstants.apiKey,
            forHTTPHeaderField: APIConstants.xApiKeyHeader
        )
        
        return urlRequest
    }
    
    let decoder = JSONDecoder()
    
    init(imageUrl: String, imageSize: ImageSize) {
        self.imageUrl = imageUrl
        self.imageSize = imageSize
    }
    
    func execute(downloader: ImageDownloading) -> AnyPublisher<Data, Error> {
        downloader.downloadImage(self)
    }
}
