//
//  CategoryViewModel.swift
//  intexsys-test-task
//
//  Created by Vladislav Khomyakov on 01.07.2022.
//

import Foundation
import UIKit

struct ProductCategoryCellViewModel {
    
    private enum Constants {
        static let titleAttributes: [NSAttributedString.Key: Any] = [
            .font : UIFont.systemFont(ofSize: 18.0)
        ]
        static let insets = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        static let spacing: CGFloat = 32.0
        static let iconSize = CGSize(width: 16.0, height: 16.0)
    }
    
    let category: ProductCategory
    
    var id: ProductCategory.Id {
        category.categoryId
    }
    var url: String {
        category.url
    }
    let attributedTitle: NSAttributedString
    let titleFrame: CGRect
    let iconFrame: CGRect
    
    var cellHeight: CGFloat {
        let insets = Constants.insets
        
        return titleFrame.height + insets.top + insets.bottom
    }
    
    init(productCategory: ProductCategory) {
        self.category = productCategory
        
        let screenWidth = UIScreen.main.bounds.width
        let insets = Constants.insets
        let iconSize = Constants.iconSize
        
        let boundingWidth = screenWidth
            - insets.left - insets.right
            - Constants.spacing
            - iconSize.width
        
        let attrubutedTitle = NSAttributedString(
            string: category.shortName,
            attributes: Constants.titleAttributes
        )
        self.attributedTitle = attrubutedTitle
        
        let titleHeight = attributedTitle
            .size(boundingWidth: boundingWidth)
            .height
        
        titleFrame = CGRect(
            x: insets.left, y: insets.top,
            width: boundingWidth, height: titleHeight.rounded()
        )
        
        let cellHeight = titleFrame.height + insets.top + insets.bottom
        
        iconFrame = CGRect(
            x: screenWidth - insets.right - iconSize.width,
            y: ((cellHeight - iconSize.height) / 2).rounded(),
            width: Constants.iconSize.width,
            height: Constants.iconSize.height
        )
    }
}

extension ProductCategoryCellViewModel: Hashable {
    static func == (lhs: ProductCategoryCellViewModel, rhs: ProductCategoryCellViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
