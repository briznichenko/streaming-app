//
//  StreamingTextField.swift
//  StreamingApp
//
//  Created by Andriy Briznichenko on 6/27/22.
//

import Foundation
import UIKit

private struct Constants {
    static let textFieldInsets = UIEdgeInsets(top: 16.0, left: 24.0, bottom: 16.0, right: 24.0)
    static let cornerRadius = 10.0
    static let borderWidth = 1.0
    static let fontSize = 12.0
    static let letterSpacing = -0.1
}

final class StreamingTextField: UITextField {
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: Constants.textFieldInsets)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: Constants.textFieldInsets)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: Constants.textFieldInsets)
    }
    
    static func styled() -> StreamingTextField {
        let textField = StreamingTextField()
        textField.defaultTextAttributes.updateValue(FontFamily.ProximaNova.medium.font(size: Constants.fontSize), forKey: .font)
        textField.defaultTextAttributes.updateValue(Constants.letterSpacing,
                                                    forKey: .kern)
        textField.backgroundColor = .black
        textField.textColor = .white
        textField.layer.cornerRadius = Constants.cornerRadius
        textField.layer.borderWidth = Constants.borderWidth
        textField.layer.borderColor = UIColor.white.cgColor
        return textField
    }
    
    func setAttributedPlaceholder(_ string: String) {
        attributedPlaceholder = NSAttributedString(
            string: string,
            attributes: [.foregroundColor: UIColor.white, .font: FontFamily.ProximaNova.medium.font(size: Constants.fontSize)]
        )
    }
}
