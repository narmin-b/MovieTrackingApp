//
//  OnboardingViewCell.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 07.02.25.
//

import UIKit

class OnboardingViewCell: UICollectionViewCell {
    private lazy var titleLabel: UILabel = {
        let label = ReusableLabel(labelText: "Title", labelColor: .white, labelFont: "Nexa-Bold", labelSize: 24, numOfLines: 2)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = ReusableLabel(labelText: "Subtitle", labelColor: .white, labelFont: "Nexa-Regular", labelSize: 16, numOfLines: 3)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .secondaryHighlight
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(slide: OnboardingSlide) {
        titleLabel.text = slide.title
        subtitleLabel.text = slide.subtitle
        imageView.image = slide.image
    }
    
    private func configureView() {
        contentView.addSubViews(imageView, titleLabel, subtitleLabel)
        
        imageView.centerXToSuperview()
        imageView.anchor(
            top: contentView.topAnchor,
            padding: .init(top: 40)
        )
        imageView.anchorSize(.init(width: 200, height: 200))

        titleLabel.anchor(
            top: imageView.bottomAnchor,
            leading: contentView.leadingAnchor,
            trailing: contentView.trailingAnchor,
            padding: .init(top: 20, left: 16, bottom: 0, right: -16)
        )
        
        subtitleLabel.anchor(
            top: titleLabel.bottomAnchor,
            leading: contentView.leadingAnchor,
            trailing: contentView.trailingAnchor,
            padding: .init(top: 8, left: 16, bottom: 0, right: -16)
        )
    }
}
