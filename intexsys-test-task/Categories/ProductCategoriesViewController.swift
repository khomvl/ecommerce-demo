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
            .map { vms -> ProductCategoriesSnapshot in
                var snapshot = ProductCategoriesSnapshot()
                snapshot.appendSections([.main])
                snapshot.appendItems(vms, toSection: .main)
                
                return snapshot
            }
            .sink(receiveValue: {
                self.dataSource.apply($0)
            })
            .store(in: &subscriptions)
    }
}

extension ProductCategoriesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item < viewModel.viewModels.count else {
            return
        }
        
        let url = viewModel.viewModels[indexPath.item].url
        
        let apiService = OpticsplanetAPIService(urlSession: .shared)
        let vm = ProductsListViewModel(apiService: apiService, categoryUrl: url)
        let vc = ProductsListViewController(viewModel: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ProductCategoriesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let viewModel = dataSource.itemIdentifier(for: indexPath) else {
            return .zero
        }
        
        return CGSize(
            width: UIScreen.main.bounds.width,
            height: viewModel.cellHeight
        )
    }
}
