//
//  ProductCategoriesViewModel.swift
//  intexsys-test-task
//
//  Created by Vladislav Khomyakov on 01.07.2022.
//

import Foundation
import Combine

final class ProductCategoriesViewModel {
    
    private let apiService: OpticsplanetAPIServicing
    
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var viewModels = [ProductCategoryCellViewModel]()
    
    init(apiService: OpticsplanetAPIServicing) {
        self.apiService = apiService
        
        reload()
    }
    
    func reload() {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
        
        ProductCategoriesRequest().execute(apiService: apiService)
            .catch { _ in Just([]) }
            .map { $0.map(ProductCategoryCellViewModel.init) }
            .receive(on: DispatchQueue.main)
            .assign(to: \.viewModels, on: self)
            .store(in: &subscriptions)
    }
}
