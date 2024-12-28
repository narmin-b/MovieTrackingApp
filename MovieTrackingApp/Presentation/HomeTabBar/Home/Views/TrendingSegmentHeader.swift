//
//  TrendingSegmentHeader.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 28.12.24.
//

import UIKit

final class TrendingSegmentHeader: UICollectionReusableView {
    private lazy var segmentLabel: UILabel = {
        let label = ReusableLabel(labelText: "Trending", labelColor: .white, labelFont: "NexaRegular", labelSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var segmentView: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Week", "Day"])
        segment.selectedSegmentIndex = 0
        segment.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
//        segment.anchorSize(.init(width: 0, height: 52))
        segment.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "NexaRegular", size: 16) ?? UIFont.systemFont(ofSize: 16)
        ], for: .normal)
        
        segment.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont(name: "Nexa-Bold", size: 16) ?? UIFont.boldSystemFont(ofSize: 16)
        ], for: .selected)
        
        segment.selectedSegmentTintColor = .primaryHighlight
        segment.addTarget(self, action: #selector(segmentClicked), for: .valueChanged)
        segment.translatesAutoresizingMaskIntoConstraints = false
        return segment
    }()
    
    private lazy var titleListLabelStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [segmentLabel, segmentView])
        stack.axis = .horizontal
        stack.backgroundColor = .clear
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    var trendingSegmentClicked: ((Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpConstrains()
    }
    
    func setUpConstrains() {
        addSubViews(titleListLabelStack)
        titleListLabelStack.fillSuperview()
    }
    
    @objc fileprivate func segmentClicked(){
        guard let trendingSegmentClicked = trendingSegmentClicked else{
            return
        }
        trendingSegmentClicked(segmentView.selectedSegmentIndex)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
