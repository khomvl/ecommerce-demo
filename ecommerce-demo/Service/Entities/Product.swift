//
//  Product.swift
//  intexsys-test-task
//
//  Created by Vladislav Khomyakov on 30.06.2022.
//

import Foundation

struct Product: Decodable {
    typealias Id = Int
    
    let id: Id
    let shortName: String
    let url: String
    let primaryImage: String
    let price: Double
}
