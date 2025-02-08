//
//  OnboardingViewCell.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 07.02.25.
//

import UIKit

class OnboardingViewCell: UICollectionViewCell {
    private lazy var titleLabel: UILabel = {
        let label = ReusableLabel(labelText: "Test", labelColor: .white, labelFont: "Nexa-Bold", labelSize: 24, numOfLines: 2)
        label.textAlignment = .left
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = ReusableLabel(labelText: "Test", labelColor: .white, labelFont: "Nexa-Bold", labelSize: 12, numOfLines: 2)
        label.textAlignment = .left
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

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
    
    func configureCell(_ slide: OnboardingSlide) {
        titleLabel.text = slide.title
        imageView.image = slide.image
        subtitleLabel.text = slide.subtitle
    }
    
    fileprivate func configureView() {
        contentView.addSubViews(imageView, titleLabel)
        backgroundColor = .blue
        
        titleLabel.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            padding: .init(top: 4, left: 16, bottom: 0, right: 0)
        )
        
        subtitleLabel.anchor(
            top: titleLabel.bottomAnchor,
            leading: leadingAnchor,
            padding: .init(top: 4, left: 16, bottom: 0, right: 0)
        )
        
        imageView.centerXToSuperview()
        imageView.anchor(
            top: subtitleLabel.bottomAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            padding: .init(top: 4, left: 16, bottom: 0, right: 16)
        )
//        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1).isActive = true
    }
}
