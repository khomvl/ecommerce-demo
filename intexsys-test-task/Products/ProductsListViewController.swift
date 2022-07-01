//
//  ProductsViewController.swift
//  intexsys-test-task
//
//  Created by Vladislav Khomyakov on 30.06.2022.
//

import UIKit
import Combine

final class ProductsListViewController: UIViewController {

    private let viewModel: ProductsListViewModel
    
    private var subscriptions = Set<AnyCancellable>()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(
            ProductCategoryCell.self,
            forCellWithReuseIdentifier: NSStringFromClass(ProductListCell.self)
        )
        
        return collectionView
    }()
    
    private lazy var dataSource = ProductsListDataSource(
        collectionView: collectionView,
        cellProvider: { collectionView, indexPath, viewModel -> UICollectionViewCell? in
            
            let reuseIdentifier = NSStringFromClass(ProductListCell.self)
            
            guard
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: reuseIdentifier,
                    for: indexPath
                ) as? ProductListCell
            else {
                fatalError("Could not dequeue cell of type \(reuseIdentifier)")
            }
            
            cell.fillIn(with: viewModel)
            
            return cell
        }
    )
    
    init(viewModel: ProductsListViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
    }

}
