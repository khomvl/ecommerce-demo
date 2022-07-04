//
//  ProductCellViewModel.swift
//  intexsys-test-task
//
//  Created by Vladislav Khomyakov on 01.07.2022.
//

import UIKit
import Combine

struct ProductCellViewModel {

    private enum Constants {
        static let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 18.0)
        ]
        static let priceTextAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 18.0, weight: .bold),
        ]
        static let insets = UIEdgeInsets(top: 12.0, left: 16.0, bottom: 12.0, right: 16.0)
        static let imageSize: CGFloat = 48.0
    }

    private let id: Product.Id
    let url: String
    let attributedTitle: NSAttributedString
    let attributedPrice: NSAttributedString
    let imageUrl: ImageUrl
    
    var cellHeight: CGFloat {
        let insets = Constants.insets
        let screenWidth = UIScreen.main.bounds.width
        
        let titleHeight = attributedTitle.size(boundingWidth: screenWidth / 2).height
        
        return ((max(titleHeight, Constants.imageSize))
            + insets.top + insets.bottom).rounded()
    }
    
    init(product: Product) {
        id = product.id
        url = product.url
        
        attributedTitle = NSAttributedString(
            string: product.shortName,
            attributes: Constants.titleAttributes
        )
        
        attributedPrice = NSAttributedString(
            string: "$\(product.price)", // use NumberFormatter
            attributes: Constants.priceTextAttributes
        )
        
        imageUrl = ImageUrl(imageId: product.primaryImage, imageSize: .small)
    }
}

extension ProductCellViewModel: Hashable {
    static func == (lhs: ProductCellViewModel, rhs: ProductCellViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
