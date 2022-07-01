//
//  ProductsViewModel.swift
//  intexsys-test-task
//
//  Created by Vladislav Khomyakov on 01.07.2022.
//

import Foundation
import Combine

final class ProductsListViewModel {
    
    private let apiService: OpticsplanetAPIServicing
    private let category: ProductCategory
    
    private var subscriptions = Set<AnyCancellable>()
    
    private lazy var imageLoaderQueue = DispatchQueue(
        label: NSStringFromClass(Self.self),
        qos: .background,
        attributes: [.concurrent]
    )
    
    var title: String {
        category.shortName
    }
    
    @Published var viewModels = [ProductCellViewModel]()
    
    init(category: ProductCategory, apiService: OpticsplanetAPIServicing) {
        self.category = category
        self.apiService = apiService
        
        reload()
    }
    
    func reload() {
        ProductsRequest(categoryUrl: category.url).execute(apiService: apiService)
            .map { $0.products.map(ProductCellViewModel.init) }
            .catch { _ in Just([])}
            .receive(on: DispatchQueue.main)
            .assign(to: \.viewModels, on: self)
            .store(in: &subscriptions)
    }
}
