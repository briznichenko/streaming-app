//
//  UIResponder+Extensions.swift
//  StreamingApp
//
//  Created by Andriy Briznichenko on 6/27/22.
//

import Foundation
import UIKit

extension UIResponder {
    static weak var currentResponder: UIResponder?

    static func getCurrentFirstResponder() -> UIResponder? {
        currentResponder = nil
        UIApplication.shared.sendAction(#selector(captureCurrentResponder), to: nil, from: nil, for: nil)
        return currentResponder
    }

    @objc private func captureCurrentResponder() {
        UIResponder.currentResponder = self
    }
}
