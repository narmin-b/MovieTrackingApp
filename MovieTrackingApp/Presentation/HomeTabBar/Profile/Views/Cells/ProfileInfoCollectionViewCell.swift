//
//  ProfileInfoCollectionViewCell.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 09.01.25.
//

import UIKit

class ProfileInfoCollectionViewCell: UICollectionViewCell {
    private lazy var titleLabel: UILabel = {
        let label = ReusableLabel(labelText: "Title", labelColor: .white, labelFont: "Nexa-Bold", labelSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = ReusableLabel(labelText: "Subtitle", labelColor: .white, labelFont: "NexaRegular", labelSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configureView() {
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(all: 8))
        
        backgroundColor = .accentMain
        layer.cornerRadius = 16
    }
    
    func configureCell(title: infoList) {
        titleLabel.text = title.rawValue.capitalized + ":"
        switch title {
        case .email:
            subtitleLabel.text = UserDefaultsHelper.getString(key: "email")
        case .username:
            subtitleLabel.text = UserDefaultsHelper.getString(key: "username")
        }
    }
}
