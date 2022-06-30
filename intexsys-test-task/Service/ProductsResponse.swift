//
//  ProductsResponse.swift
//  intexsys-test-task
//
//  Created by Vladislav Khomyakov on 30.06.2022.
//

import Foundation

struct ProductsResponse: Decodable {
    let products: [Product]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        let gridProductsContainer = try container.nestedContainer(
            keyedBy: Keys.GridProductsKeys.self,
            forKey: .gridProducts
        )
        
        products = try gridProductsContainer.decode([Product].self, forKey: .elements)
    }
    
    enum Keys: String, CodingKey {
        case gridProducts
        
        enum GridProductsKeys: String, CodingKey {
            case elements
        }
    }
}
