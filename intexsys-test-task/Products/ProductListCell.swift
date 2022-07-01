//
//  ProductListCell.swift
//  intexsys-test-task
//
//  Created by Vladislav Khomyakov on 01.07.2022.
//

import UIKit
import Combine

final class ProductListCell: UICollectionViewCell {
    
    var subscriptions = Set<AnyCancellable>()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        [imageView, titleLabel, priceLabel].forEach {
            contentView.addSubview($0)
        }
        
        let layout = [
            imageView.heightAnchor.constraint(equalToConstant: 48.0),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16.0),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: priceLabel.leadingAnchor, constant: -16.0),
            
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            priceLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(layout)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        // move to superclass?
        let scaleAnimation = CABasicAnimation(keyPath: "transform")
        scaleAnimation.fromValue = CATransform3DMakeScale(1, 1, 1)
        scaleAnimation.toValue = CATransform3DMakeScale(0.9, 0.9, 1)
        scaleAnimation.duration = 0.1
        
        contentView.layer.add(scaleAnimation, forKey: nil)
    }
    
    func fillIn(with viewModel: ProductCellViewModel) {
        titleLabel.attributedText = viewModel.attributedTitle
        priceLabel.attributedText = viewModel.attributedPrice
    }
    
    func set(image: UIImage?) {
        imageView.image = image
    }
}
