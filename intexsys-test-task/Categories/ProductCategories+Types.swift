//
//  ProductCategories+Types.swift
//  intexsys-test-task
//
//  Created by Vladislav Khomyakov on 01.07.2022.
//

import UIKit

enum ProductCategoriesSection {
    case main
}

typealias ProductCategoriesDataSource = UICollectionViewDiffableDataSource<ProductCategoriesSection, ProductCategoryCellViewModel>

typealias ProductCategoriesSnapshot = NSDiffableDataSourceSnapshot<ProductCategoriesSection, ProductCategoryCellViewModel>
