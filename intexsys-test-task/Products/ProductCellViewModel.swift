//
//  ProductCellViewModel.swift
//  intexsys-test-task
//
//  Created by Vladislav Khomyakov on 01.07.2022.
//

import Foundation

struct ProductCellViewModel {
    
    private let id: Product.Id
    
    init(product: Product) {
        id = product.id
    }
}

extension ProductCellViewModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
