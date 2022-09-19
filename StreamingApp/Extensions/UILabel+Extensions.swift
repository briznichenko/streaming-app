//
//  UILabel+Extensions.swift
//  StreamingApp
//
//  Created by Andriy Briznichenko on 6/21/22.
//

import Foundation
import UIKit

extension UILabel {
    func setText(_ text: String, withLetterSpacing spacing: Double) {
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.kern, value: spacing, range: NSMakeRange(0, attributedString.length))
        attributedText = attributedString
    }
    
    func setMargins(left: CGFloat = 10, right: CGFloat = 10, top: CGFloat = 10, bottom: CGFloat = 10) {
        guard let text = text else { return }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = left
        paragraphStyle.headIndent = right
        paragraphStyle.tailIndent = -top
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        attributedText = attributedString
    }
    
}
