//
//  ProductsList+Types.swift
//  intexsys-test-task
//
//  Created by Vladislav Khomyakov on 01.07.2022.
//

import UIKit

enum ProductsListSection {
    case main
}

typealias ProductsListDataSource = UICollectionViewDiffableDataSource<ProductsListSection, ProductCellViewModel>

typealias ProductsListSnapshot = NSDiffableDataSourceSnapshot<ProductsListSection, ProductCellViewModel>
