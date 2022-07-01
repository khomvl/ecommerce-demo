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
    private let categoryUrl: String
    
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var viewModels = [ProductCellViewModel]()
    
    init(apiService: OpticsplanetAPIServicing, categoryUrl: String) {
        self.apiService = apiService
        self.categoryUrl = categoryUrl
    }
    
    func reload() {
        ProductsRequest(categoryUrl: categoryUrl).execute(apiService: apiService)
            .catch { _ in Just([]) }
            .map { $0.map { ProductCellViewModel(product: $0) } }
            .receive(on: DispatchQueue.main)
            .assign(to: \.viewModels, on: self)
            .store(in: &subscriptions)
    }
}
