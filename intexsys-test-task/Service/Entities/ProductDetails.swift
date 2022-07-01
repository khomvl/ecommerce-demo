//
//  ProductDetails.swift
//  intexsys-test-task
//
//  Created by Vladislav Khomyakov on 30.06.2022.
//

import Foundation

struct ProductDetails: Decodable {
    let productId: Product.Id
    let shortName: String
    let primaryImage: String
    let cleanDescription: String
    let minSalePrice: Double
}
