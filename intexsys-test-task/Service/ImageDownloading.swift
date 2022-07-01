//
//  ImageDownloading.swift
//  intexsys-test-task
//
//  Created by Vladislav Khomyakov on 30.06.2022.
//

import Foundation
import Combine

protocol ImageDownloading {
    func downloadImage(_ request: Requestable) -> AnyPublisher<Data, Error>
}
