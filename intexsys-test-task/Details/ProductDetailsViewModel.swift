//
//  ProductDetailsViewModel.swift
//  intexsys-test-task
//
//  Created by Vladislav Khomyakov on 01.07.2022.
//

import Foundation
import Combine
import UIKit

final class ProductDetailsViewModel {
    
    private enum Constants {
        static let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 18.0, weight: .medium)
        ]
        static let priceTextAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 24.0, weight: .bold)
        ]
        static let descriptionTextAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16.0)
        ]
    }
    
    private let apiService: OpticsplanetAPIServicing
    
    @Published var attributedTitle: NSAttributedString?
    @Published var attributedPrice: NSAttributedString?
    @Published var attributedDescription: NSAttributedString?
    @Published var image: UIImage?
    
    private var cancellable: AnyCancellable?
    
    init(productUrl: String, apiService: OpticsplanetAPIServicing) {
        self.apiService = apiService
        
        cancellable = ProductDetailsRequest(productUrl: productUrl)
            .execute(apiService: apiService)
            .sink { [weak self] error in
                self?.cancellable = nil
            } receiveValue: { [weak self] details in
                guard let self = self else { return }
                
                self.attributedTitle = NSAttributedString(
                    string: details.shortName,
                    attributes: Constants.titleAttributes
                )
                self.attributedPrice = NSAttributedString(
                    string: "$\(details.minSalePrice)",
                    attributes: Constants.priceTextAttributes
                )
                self.attributedDescription = NSAttributedString(
                    string: details.cleanDescription,
                    attributes: Constants.descriptionTextAttributes
                )
                
                let imageUrl = ImageUrl(
                    imageId: details.primaryImage,
                    imageSize: .large
                )
                
                if let data = try? Data(contentsOf: imageUrl.url) {
                    self.image = UIImage(data: data)
                }
                
                self.cancellable = nil
            }
    }
}
