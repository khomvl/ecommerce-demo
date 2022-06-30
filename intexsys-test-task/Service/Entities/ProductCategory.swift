//
//  ProductCategory.swift
//  intexsys-test-task
//
//  Created by Vladislav Khomyakov on 30.06.2022.
//

import Foundation

typealias CategoryId = String

struct ProductCategory: Decodable {
    let categoryId: CategoryId
    let shortName: String
    let url: String
}
