//
//  StreamingStatusLabel.swift
//  StreamingApp
//
//  Created by Andriy Briznichenko on 6/28/22.
//

import Foundation
import UIKit

private struct Constants {
    static let insets = UIEdgeInsets(top: 3, left: 7, bottom: 3, right: 6)
    static let cornerRadius = 2.0
}

final class StreamingStatusLabel: UILabel {
    var textInsets = Constants.insets {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = Constants.cornerRadius
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layer.cornerRadius = Constants.cornerRadius
        clipsToBounds = true
    }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = bounds.inset(by: textInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(
            top: -textInsets.top,
            left: -textInsets.left,
            bottom: -textInsets.bottom,
            right: -textInsets.right
        )
        return textRect.inset(by: invertedInsets)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
    
    
}
