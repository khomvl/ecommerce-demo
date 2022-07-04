//
//  ImageFetchOperation.swift
//  intexsys-test-task
//
//  Created by Vladislav Khomyakov on 01.07.2022.
//

import UIKit

final class ImageFetchOperation: Operation {
    
    private let url: URL
    
    var onFetchComplete: ((UIImage?) -> Void)?
    
    init(url: URL) {
        self.url = url
    }
    
    override func main() {
        if isCancelled { return }
        
        var image: UIImage?
        if let data = try? Data(contentsOf: url) {
            image = UIImage(data: data)
        }
        
        DispatchQueue.main.async {
            self.onFetchComplete?(image)
        }
    }
}
