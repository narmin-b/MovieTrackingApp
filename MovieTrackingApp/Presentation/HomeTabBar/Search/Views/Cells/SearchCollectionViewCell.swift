//
//  SearchCollectionViewCell.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 08.01.25.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {
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
    
    private lazy var titleLabel: UILabel = {
        let label = ReusableLabel(labelText: "Test", labelColor: .white, labelFont: "Nexa-Bold", labelSize: 24, numOfLines: 2)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = ReusableLabel(labelText: "Test", labelColor: .white, labelFont: "Nexa-Bold", labelSize: 16, numOfLines: 1)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var overViewLabel: UILabel = {
        let label = ReusableLabel(labelText: "Test", labelColor: .white, labelFont: "Nexa-Bold", labelSize: 12, numOfLines: 4)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, ratingLabel])
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var overviewStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleStackView, overViewLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
        DispatchQueue.main.async {
            self.titleLabel.text = model?.titleString
            self.imageView.loadImageURL(url: self.baseImageURL + (model?.imageString ?? ""))
            self.overViewLabel.text = model?.overviewString
            self.ratingLabel.configureLabel(icon: "star.fill", text: model?.ratingString ?? "")
        }
    }
    
    fileprivate func configureView() {
        contentView.addSubViews(imageView, overviewStackView)

        imageView.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: titleStackView.leadingAnchor,
            padding: .init(all: 4)
        )
        imageView.heightAnchor.constraint(equalToConstant: self.frame.height - 4).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.5).isActive = true
        
        overviewStackView.anchor(
            top: topAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor,
            padding: .init(all: 4)
        )
        overviewStackView.heightAnchor.constraint(equalToConstant: imageView.frame.height).isActive = true
        titleStackView.anchor(
            top: overviewStackView.topAnchor,
            trailing: overviewStackView.trailingAnchor,
            padding: .init(all: 0)
        )
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        ratingLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        ratingLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
}
