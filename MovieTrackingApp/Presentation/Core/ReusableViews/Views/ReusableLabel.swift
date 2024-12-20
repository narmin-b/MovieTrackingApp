//
//  ReusableLabel.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 19.12.24.
//

import UIKit

class ReusableLabel: UILabel {
    private var labelText: String!
    private var labelColor: UIColor
    private var labelFont: String
    private var labelSize: CGFloat
    private var numOfLines: Int
    private var bgColor: UIColor
    
    init(labelText: String!, labelColor: UIColor = .black, labelFont: String = "Futura", labelSize: CGFloat = 12, numOfLines: Int = 1, bgColor: UIColor = .clear) {
        self.labelText = labelText
        self.labelColor = labelColor
        self.labelFont = labelFont
        self.labelSize = labelSize
        self.numOfLines = numOfLines
        self.bgColor = bgColor
        super.init(frame: .zero)
        configureLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLabel() {
        text = labelText
        textColor = labelColor
        textAlignment = .left
        font = UIFont(name: labelFont, size: labelSize)
        numberOfLines = numOfLines
        backgroundColor = bgColor
    }
}
