//
//  TitleImageCollectionViewCell.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 20.12.24.
//

import UIKit

class TitleImageCollectionViewCell: UICollectionViewCell {
    private lazy var titleLabel: UILabel = {
        let label = ReusableLabel(labelText: "Test", labelSize: 24)
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.anchorSize(.init(width: 80, height: 120))
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.image = UIImage(named: "testing")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell() {
       
    }
    
    fileprivate func configureView() {
        addSubViews(imageView, titleLabel)
        
        imageView.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            padding: .init(top: 4, left: 16, bottom: 0, right: 0)
        )
        titleLabel.anchor(
            top: imageView.bottomAnchor,
            leading: leadingAnchor,
            padding: .init(top: 4, left: 16, bottom: 0, right: 0)
        )
    }
}
