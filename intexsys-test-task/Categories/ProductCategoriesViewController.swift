//
//  ProductCategoriesViewController.swift
//  intexsys-test-task
//
//  Created by Vladislav Khomyakov on 30.06.2022.
//

import UIKit
import Combine

final class ProductCategoriesViewController: UIViewController {

    private let viewModel: ProductCategoriesViewModel
    
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
            forCellWithReuseIdentifier: NSStringFromClass(ProductCategoryCell.self)
        )
        
        return collectionView
    }()
    
    private lazy var dataSource = ProductCategoriesDataSource(
        collectionView: collectionView,
        cellProvider: { collectionView, indexPath, viewModel -> UICollectionViewCell? in
            
            let reuseIdentifier = NSStringFromClass(ProductCategoryCell.self)
            
            guard
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: reuseIdentifier,
                    for: indexPath
                ) as? ProductCategoryCell
            else {
                fatalError("Could not dequeue cell of type \(reuseIdentifier)")
            }
            
            cell.fillIn(with: viewModel)
            
            return cell
        }
    )
    
    init(viewModel: ProductCategoriesViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Categories"
        
        view.addSubview(collectionView)
        collectionView.delegate = self
        
        let layout = [
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ]
        
        NSLayoutConstraint.activate(layout)
        
        viewModel.$viewModels
            .map {
                var snapshot = ProductCategoriesSnapshot()
                snapshot.appendSections([.main])
                snapshot.appendItems($0, toSection: .main)
                
                return snapshot
            }
            .sink(receiveValue: {
                self.dataSource.apply($0)
            })
            .store(in: &subscriptions)

        viewModel.reload()
    }
}

extension ProductCategoriesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item < viewModel.viewModels.count else {
            return
        }
        
        let viewModel = viewModel.viewModels[indexPath.item]
        
        let productsVC = ProductsViewController()
        navigationController?.pushViewController(productsVC, animated: true)
    }
}

extension ProductCategoriesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard indexPath.item < viewModel.viewModels.count else {
            return .zero
        }
        
        return CGSize(
            width: UIScreen.main.bounds.width,
            height: viewModel.viewModels[indexPath.item].cellHeight
        )
    }
}
