//
//  TrendingTitleCell.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 28.12.24.
//

import UIKit

class TrendingTitleCell: UICollectionViewCell {
    private lazy var titleLabel: UILabel = {
        let label = ReusableLabel(labelText: "Testjnrerifnbwejrfeijfneirfefj", labelColor: .white, labelFont: "Nexa-Bold", labelSize: 24, numOfLines: 2)
        label.textAlignment = .center
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
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [imageView, titleLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
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
        titleLabel.text = model?.titleString
        imageView.loadImageURL(url:baseImageURL + (model?.imageString ?? ""))
    }
    
    fileprivate func configureView() {
        contentView.addSubViews(stackView)

        imageView.centerXToView(to: stackView)
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.5).isActive = true
        imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.65).isActive = true
        titleLabel.centerXToView(to: stackView)

        stackView.fillSuperview()
    }
}
