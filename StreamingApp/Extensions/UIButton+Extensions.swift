//
//  UIButton+Extensions.swift
//  StreamingApp
//
//  Created by Andriy Briznichenko on 6/25/22.
//

import Foundation
import UIKit

private struct Constants {
    static let fontSize = 16.0
    static let cornerRadius = 15.0
    static let borderWidth = 1.0
}

extension UIButton {
    func StreamingStyle() {
        titleLabel?.font = FontFamily.ProximaNova.bold.font(size: Constants.fontSize)
        setTitleColor(.white, for: .normal)
        setTitleColor(.gray, for: .selected)
        layer.cornerRadius = Constants.cornerRadius
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = Constants.borderWidth
    }
    
    func StreamingStyleWhite() {
        StreamingStyle()
        setTitleColor(.black, for: .normal)
        backgroundColor = .white
    }
    
    func setAttributedTitleForAllStates(_ string: String, font: UIFont, kern: CGFloat = 0.0, foregroundColor: UIColor = .white) {
        let title: NSMutableAttributedString = NSMutableAttributedString(string: string,
                                                                         attributes: [.font: font,
                                                                                      .kern: kern,
                                                                                      .foregroundColor: foregroundColor])
        setAttributedTitle(title, for: .normal)
        
        if let copy = title.copy() as? NSAttributedString {
            let disabledTitle = NSMutableAttributedString(attributedString: copy)
            disabledTitle.addAttributes([.foregroundColor: UIColor.gray], range: NSRange(location: 0, length: title.length))
            setAttributedTitle(disabledTitle, for: .disabled)
        }
        
        if let copy = title.copy() as? NSAttributedString {
            let highlightedTitle = NSMutableAttributedString(attributedString: copy)
            highlightedTitle.addAttributes([.foregroundColor: Asset.Colors.c1c1c1.color], range: NSRange(location: 0, length: title.length))
            setAttributedTitle(highlightedTitle, for: .highlighted)
        }
    }
    
    func setTitleForAllStates(_ string: String, font: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize), foregroundColor: UIColor = .white) {
        setTitle(string, for: .normal)
        titleLabel?.font = font
        setTitleColor(foregroundColor, for: .normal)
        setTitleColor(.gray, for: .disabled)
        setTitleColor(Asset.Colors.c1c1c1.color, for: .highlighted)
    }
}
