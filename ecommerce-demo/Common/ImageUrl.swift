//
//  ImageRequest.swift
//  intexsys-test-task
//
//  Created by Vladislav Khomyakov on 01.07.2022.
//

import Foundation
import Combine

final class ImageUrl {
    
    enum ImageSize: Hashable {
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
    
    private let imageId: String
    private let imageSize: ImageSize
    
    var url: URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "op1.0ps.us"
        urlComponents.path = "/\(imageSize.urlPath)/\(imageId).jpg"
        
        return urlComponents.url!
    }
    
    init(imageId: String, imageSize: ImageSize) {
        self.imageId = imageId
        self.imageSize = imageSize
    }
}

extension ImageUrl: Hashable {
    static func == (lhs: ImageUrl, rhs: ImageUrl) -> Bool {
        lhs.url == rhs.url
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(url)
    }
}
