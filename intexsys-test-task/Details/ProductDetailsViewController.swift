//
//  ProductDetailsViewController.swift
//  intexsys-test-task
//
//  Created by Vladislav Khomyakov on 30.06.2022.
//

import UIKit
import Combine

final class ProductDetailsViewController: UIViewController {
    
    private let viewModel: ProductDetailsViewModel
    
    private var subscriptions = Set<AnyCancellable>()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    init(viewModel: ProductDetailsViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        title = "Product details" // to localizables
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Home",
            style: .done,
            target: self,
            action: #selector(navigateHome)
        )
        
        configureLayout()
        configureSubscriptions()
    }
    
    @objc
    private func navigateHome() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func configureLayout() {
        view.addSubview(scrollView)
        
        [titleLabel, priceLabel, descriptionLabel, imageView].forEach {
            scrollView.addSubview($0)
        }
        
        let layout = [
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            imageView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16.0),
            titleLabel.leadingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: priceLabel.leadingAnchor, constant: -32.0),
            
            priceLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.trailingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.0),
            descriptionLabel.leadingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(layout)
    }
    
    private func configureSubscriptions() {
        viewModel.$attributedTitle
            .receive(on: DispatchQueue.main)
            .assign(to: \.attributedText, on: titleLabel)
            .store(in: &subscriptions)
        
        viewModel.$attributedPrice
            .receive(on: DispatchQueue.main)
            .assign(to: \.attributedText, on: priceLabel)
            .store(in: &subscriptions)
        
        viewModel.$attributedDescription
            .receive(on: DispatchQueue.main)
            .assign(to: \.attributedText, on: descriptionLabel)
            .store(in: &subscriptions)
        
        viewModel.$image
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: imageView)
            .store(in: &subscriptions)
    }

}
