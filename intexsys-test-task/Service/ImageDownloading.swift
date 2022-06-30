//
//  ImageDownloading.swift
//  intexsys-test-task
//
//  Created by Vladislav Khomyakov on 30.06.2022.
//

import Foundation
import Combine

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

protocol ImageDownloading {
    func getImage(imageUrl: String, size: ImageSize) -> AnyPublisher<Data, Error>
}
