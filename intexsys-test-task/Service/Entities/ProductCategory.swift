//
//  ProductCategory.swift
//  intexsys-test-task
//
//  Created by Vladislav Khomyakov on 30.06.2022.
//

import Foundation

struct ProductCategory: Decodable {
    typealias Id = String
    
    let categoryId: Id
    let shortName: String
    let url: String
}
