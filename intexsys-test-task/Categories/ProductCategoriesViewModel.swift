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
    
    @Published var viewModels = [ProductCategoryViewModel]()
    
    init(apiService: OpticsplanetAPIServicing) {
        self.apiService = apiService
        
        reload()
    }
    
    func reload() {
        apiService.getCategories()
            .catch { _ in Just([]) }
            .map { $0.map { ProductCategoryViewModel(productCategory: $0) } }
            .receive(on: DispatchQueue.main)
            .assign(to: \.viewModels, on: self)
            .store(in: &subscriptions)
    }
}
