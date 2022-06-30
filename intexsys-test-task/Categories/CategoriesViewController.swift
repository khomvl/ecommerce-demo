//
//  CategoriesViewController.swift
//  intexsys-test-task
//
//  Created by Vladislav Khomyakov on 30.06.2022.
//

import UIKit
import Combine

final class CategoriesViewController: UIViewController {

    private var cancellable: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancellable = OpticsplanetAPIService(urlSession: URLSession.shared)
            .getCategories()
            .sink { error in
                print(error)
            } receiveValue: { products in
                print(products)
                self.cancellable = nil
            }

        print("aslkgnsldkg")
    }
    
}
