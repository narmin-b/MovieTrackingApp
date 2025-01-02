//
//  ReusableTextField.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 19.12.24.
//

import UIKit

class ReusableTextField: UITextField {
    private var placeholderTitle: String
    private var placeholderFont: String
    private var placeholderSize: CGFloat
    private var placeholderColor: UIColor
    private var iconName: String?
    private var iconSetting: Int?
    private var iconTintColor: UIColor?
    private var cornerRad: CGFloat
    private var bgColor: UIColor
    private var borderColor: UIColor
    private var borderWidth: CGFloat
    
    init(placeholder: String!,
         iconName: String?,
         placeholderSize: CGFloat = 16,
         placeholderFont: String = "Futura",
         placeholderColor: UIColor = .gray,
         iconSetting: Int = 10,
         iconTintColor: UIColor = .black,
         cornerRadius: CGFloat = 12,
         backgroundColor: UIColor = .white,
         borderColor: UIColor = .gray,
         borderWidth: CGFloat = 1) {
        self.placeholderTitle = placeholder
        self.placeholderFont = placeholderFont
        self.placeholderSize = placeholderSize
        self.placeholderColor = placeholderColor
        self.iconName = iconName
        self.iconSetting = iconSetting
        self.iconTintColor = iconTintColor
        self.cornerRad = cornerRadius
        self.bgColor = backgroundColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        super.init(frame: .zero)
        configurePlaceholder()
        configureIcon()
    }
    
    init(placeholder: String!,
         placeholderSize: CGFloat = 16,
         placeholderFont: String = "Futura",
         placeholderColor: UIColor = .gray,
         cornerRadius: CGFloat = 12,
         backgroundColor: UIColor = .white,
         borderColor: UIColor = .gray,
         borderWidth: CGFloat = 1) {
        self.placeholderTitle = placeholder
        self.placeholderFont = placeholderFont
        self.placeholderSize = placeholderSize
        self.placeholderColor = placeholderColor
        self.cornerRad = cornerRadius
        self.bgColor = backgroundColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        super.init(frame: .zero)
        configurePlaceholder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configurePlaceholder() {
        let attributes = [NSAttributedString.Key.baselineOffset : NSNumber(-2.0), .foregroundColor: placeholderColor.withAlphaComponent(0.4), .font: UIFont(name: placeholderFont, size: placeholderSize)!]

        attributedPlaceholder = NSAttributedString(string: placeholderTitle, attributes: attributes)
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
        layer.cornerRadius = cornerRad
        layer.backgroundColor = bgColor.cgColor
    }
    
    private func configureIcon() {
        leftView = iconUISetting(iconName ?? "", x: iconSetting ?? 10)
        leftViewMode = .always
    }
    
    fileprivate func iconUISetting(_ iconName: String, x: Int = 10) -> UIView {
        let icon = UIImageView(image: UIImage(systemName: iconName))
        icon.tintColor = iconTintColor
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: icon.frame.height))
        icon.frame = CGRect(x: CGFloat(integerLiteral: x), y: 0, width: icon.frame.width, height: icon.frame.height)
        paddingView.addSubview(icon)
        return paddingView
    }
}
