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

typealias ProductCategoriesDataSource = UICollectionViewDiffableDataSource<ProductCategoriesSection, ProductCategoryViewModel>

typealias ProductCategoriesSnapshot = NSDiffableDataSourceSnapshot<ProductCategoriesSection, ProductCategoryViewModel>
