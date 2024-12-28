//
//  TitlesSwitchCollectionViewCell.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 27.12.24.
//

import UIKit

protocol TitlesSwitchSegmentCellDelegate: AnyObject {
    func didClickSegment(index: Int)
}

final class TitlesSwitchSegmentCell: UICollectionViewCell {
    private lazy var segmentView: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Movies", "Tv Shows"])
        segment.selectedSegmentIndex = 0
        segment.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        segment.anchorSize(.init(width: 0, height: 52))
        segment.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "NexaRegular", size: 16) ?? UIFont.systemFont(ofSize: 16)
        ], for: .normal)
        
        segment.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont(name: "Nexa-Bold", size: 24) ?? UIFont.boldSystemFont(ofSize: 16)
        ], for: .selected)
        
        segment.selectedSegmentTintColor = .secondaryHighlight
        segment.addTarget(self, action: #selector(segmentClicked), for: .valueChanged)
        segment.translatesAutoresizingMaskIntoConstraints = false
        return segment
    }()
    
    weak var delegate: TitlesSwitchSegmentCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func configureView() {
        addSubview(segmentView)
        segmentView.fillSuperview()
    }
    
    @objc private func segmentClicked() {
        delegate?.didClickSegment(index: segmentView.selectedSegmentIndex)
    }
}
