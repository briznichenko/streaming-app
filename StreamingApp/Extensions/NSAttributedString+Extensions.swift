//
//  NSAttributedString+Extensions.swift
//  StreamingApp
//
//  Created by Andriy Briznichenko on 7/4/22.
//

import Foundation
import UIKit

extension NSMutableAttributedString {
    func setColor(_ color: UIColor, at range: NSRange) {
        beginEditing()
        enumerateAttribute(.foregroundColor, in: range) { value, range, stop in
            removeAttribute(.foregroundColor, range: range)
            addAttribute(.foregroundColor, value: color, range: range)
        }
        endEditing()
    }
}

extension NSAttributedString {
    func findLinkRange(at index: Int) -> NSRange? {
        var linkRange: NSRange? = nil
        enumerateAttribute(.link, in: NSRange(location: 0, length: length)) { _, range, _ in
            if range.contains(index) {
                linkRange = range
            }
        }
        return linkRange
    }
}
