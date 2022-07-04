//
//  ProductCategoryCell.swift
//  intexsys-test-task
//
//  Created by Vladislav Khomyakov on 01.07.2022.
//

import UIKit

final class ProductCategoryCell: UICollectionViewCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    
    private let iconView: UIImageView = {
        let image = UIImage(systemName: "chevron.right")
        let imageView = UIImageView(image: image)
        imageView.tintColor = .lightGray
        imageView.backgroundColor = .white
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [titleLabel, iconView].forEach {
            contentView.addSubview($0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fillIn(with viewModel: ProductCategoryCellViewModel) {
        titleLabel.frame = viewModel.titleFrame
        titleLabel.attributedText = viewModel.attributedTitle
        titleLabel.sizeToFit()
        
        iconView.frame = viewModel.iconFrame
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform")
        scaleAnimation.fromValue = CATransform3DMakeScale(1, 1, 1)
        scaleAnimation.toValue = CATransform3DMakeScale(0.9, 0.9, 1)
        scaleAnimation.duration = 0.1
        
        contentView.layer.add(scaleAnimation, forKey: nil)
    }
}
