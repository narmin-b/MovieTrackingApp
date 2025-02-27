//
//  ListSectionHeader.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 27.12.24.
//

import Foundation
import UIKit

final class ListSectionHeader: UICollectionReusableView {
    private lazy var titleListLabel: UILabel = {
        let label = ReusableLabel(labelText: "Popular Movies", labelColor: .white, labelFont: "NexaRegular", labelSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var titleListSeeAllButton: UIButton = {
        let button = ReusableButton(
            title: "See All",
            onAction: { [weak self] in self?.seeAllButtonClicked() },
            bgColor: .clear,
            titleColor: .primaryHighlight
        )
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "chevron.right")
        config.imagePlacement = .trailing
        config.imagePadding = 8
        config.baseForegroundColor = .primaryHighlight
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var titleListLabelStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleListLabel, titleListSeeAllButton])
        stack.axis = .horizontal
        stack.backgroundColor = .clear
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    var seeAllButtonAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpConstrains()
    }
    
    func setUpConstrains() {
        addSubViews(titleListLabelStack)
        titleListLabelStack.fillSuperview()
    }
    
    func configure(with title: String) {
        titleListLabel.text = title
    }
    
    @objc fileprivate func seeAllButtonClicked(){
        guard let seeAllButtonAction = seeAllButtonAction else{
            return
        }
        seeAllButtonAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
