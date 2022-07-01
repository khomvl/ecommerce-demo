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
    
    // <extract to another class>
    private let imageFetchQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .background
        
        return queue
    }()
    private var imageFetchOperations: [IndexPath: ImageFetchOperation] = [:]
    private var fetchedImages: [IndexPath: UIImage] = [:]
    // </extract to another class>
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(
            ProductListCell.self,
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
        title = viewModel.title
        
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
        
        let layout = [
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ]
        
        NSLayoutConstraint.activate(layout)
        
        viewModel.$viewModels
            .map { vms -> ProductsListSnapshot in
                var snapshot = ProductsListSnapshot()
                snapshot.appendSections([.main])
                snapshot.appendItems(vms, toSection: .main)
                
                return snapshot
            }
            .sink(receiveValue: { [weak self] in
                self?.dataSource.apply($0)
            })
            .store(in: &subscriptions)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        imageFetchOperations.forEach { (_, op) in
            op.cancel()
        }
        imageFetchOperations.removeAll()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        fetchedImages.removeAll()
    }
}

extension ProductsListViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView,
                        prefetchItemsAt indexPaths: [IndexPath]) {
        
        indexPaths.forEach { indexPath in
            guard
                let item = dataSource.itemIdentifier(for: indexPath),
                imageFetchOperations[indexPath] == nil,
                fetchedImages[indexPath] == nil
            else {
                return
            }
            
            let operation = ImageFetchOperation(url: item.imageUrl.url)
            operation.onFetchComplete = { [weak self] image in
                guard
                    let self = self,
                    let img = image
                else {
                    return
                }
                
                self.fetchedImages[indexPath] = img
                self.imageFetchOperations[indexPath] = nil
            }
            imageFetchOperations[indexPath] = operation
            imageFetchQueue.addOperation(operation)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        
        indexPaths.forEach { indexPath in
            if let operation = imageFetchOperations[indexPath] {
                operation.cancel()
                imageFetchOperations[indexPath] = nil
            }
        }
    }
}

extension ProductsListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        guard
            let productListCell = cell as? ProductListCell,
            let item = dataSource.itemIdentifier(for: indexPath)
        else {
            return
        }
        
        if let image = fetchedImages[indexPath] {
            productListCell.set(image: image)
            return
        }
        
        let updateCellClosure: (UIImage?) -> Void = { [weak self] image in
            self?.fetchedImages[indexPath] = image
            productListCell.set(image: image)
            self?.imageFetchOperations[indexPath] = nil
        }
        
        if let operation = imageFetchOperations[indexPath] {
            operation.onFetchComplete = updateCellClosure
            return
        }
        
        let operation = ImageFetchOperation(url: item.imageUrl.url)
        operation.onFetchComplete = updateCellClosure
        imageFetchOperations[indexPath] = operation
        imageFetchQueue.addOperation(operation)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplaying cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        
        if let operation = imageFetchOperations[indexPath] {
            operation.cancel()
            imageFetchOperations[indexPath] = nil
        }
    }
}

extension ProductsListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        guard let viewModel = dataSource.itemIdentifier(for: indexPath) else {
            return .zero
        }
        
        return CGSize(
            width: UIScreen.main.bounds.width,
            height: viewModel.cellHeight
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        .zero
    }
}
