//
//  ImageCollectionViewCell.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 22.12.24.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.layer.borderWidth = 0.3
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.image = UIImage(named: "testing")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var baseImageURL = "https://image.tmdb.org/t/p/w500"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(model: TitleImageCellProtocol?) {
        imageView.loadImageURL(url:baseImageURL + (model?.imageString ?? ""))
    }
    
    fileprivate func configureView() {
        contentView.addSubViews(imageView)
        
        imageView.centerXToSuperview()
        imageView.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            padding: .init(top: 4, left: 0, bottom: 0, right: 0)
        )
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.5).isActive = true
    }
}
