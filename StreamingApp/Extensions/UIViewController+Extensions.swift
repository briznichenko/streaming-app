//
//  UIViewController+Extensions.swift
//  StreamingApp
//
//  Created by Andriy Briznichenko on 6/27/22.
//

import Foundation
import UIKit

// MARK: - Keyboard

public typealias DeltaCalculationClosure = (KeyboardInfo) -> CGFloat
public typealias KeyboardNotificationCallback = (KeyboardInfo) -> Void

fileprivate extension Selector {
    static let keyboardWillShow = #selector(UIViewController.keyboardWillShow(_:))
    static let keyboardWillHide = #selector(UIViewController.keyboardWillHide(_:))
}

extension UIViewController {
    public func addKeyboardNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: .keyboardWillShow, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: .keyboardWillHide, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    public func removeKeyboardNotificationObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func calculateDelta(for keyboardInfo: KeyboardInfo) -> CGFloat? {
        return keyboardInfo.keyboardHeightInSafeArea(keyboardFrame: keyboardInfo.endFrame, inside: view)
    }
    
    // MARK: - Notifications
    
    @objc fileprivate func keyboardWillShow(_ notification: Notification) {
        guard let keyboardInfo = KeyboardInfo(notification: notification),
              let delta = calculateDelta(for: keyboardInfo) else {
            return
        }
        
        let keyboardSpacing: CGFloat = 5.0
        
        var textFieldY: CGFloat = 0.0
        var viewY: CGFloat = 0.0
        var frame: CGRect = .zero
        
    
        if let activeTextField = UIResponder.getCurrentFirstResponder() as? UITextField ?? UIResponder.getCurrentFirstResponder() as? UITextView {
            frame = view.convert(activeTextField.frame, from: activeTextField.superview)
            textFieldY = frame.origin.y + frame.size.height
        }
        
        let keyboardY = keyboardInfo.endFrame.origin.y
        if keyboardY >= UIScreen.main.bounds.size.height {
            viewY = 0.0
        } else {
            if textFieldY >= keyboardY {
                viewY = (textFieldY - keyboardY) + keyboardSpacing
                if viewY > delta { viewY = delta }
            }
        }
        
        keyboardInfo.animateView({ [weak self] in
            self?.view.frame.origin.y = -viewY
            self?.view.layoutIfNeeded()
        })
    }
    
    @objc fileprivate func keyboardWillHide(_ notification: Notification) {
        guard let keyboardInfo = KeyboardInfo(notification: notification) else { return }
        keyboardInfo.animateView({ [weak self] in
            self?.view.frame.origin.y = 0
            self?.view.layoutIfNeeded()
        })
    }
}

// MARK: - Child management

extension UIViewController {
    func addChild(_ child: UIViewController, in containerView: UIView) {
        guard containerView.isDescendant(of: view) else { return }
        addChild(child)
        containerView.addSubview(child.view)
        view.embedView(child.view)
        child.didMove(toParent: self)
    }
    
    func removeChild(_ child: UIViewController) {
        child.willMove(toParent: nil)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }
}
