//
//  Product.swift
//  intexsys-test-task
//
//  Created by Vladislav Khomyakov on 30.06.2022.
//

import Foundation

typealias ProductId = Int

struct Product: Decodable {
    let id: ProductId
    let shortName: String
    let url: String
    let primaryImage: String
    let price: Double
}
