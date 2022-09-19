//
//  SignInViewController.swift
//  StreamingApp
//
//  Created by Andriy Briznichenko on 6/21/22.
//

import Foundation
import UIKit
import SnapKit

private struct Constants {
    static let privacyPolicyURLString = "https://streamingsamplename.com/policy"
    
    struct SignIn {
        static let fontSize = 32.0
        static let letterSpacing = -0.26
    }
    
    struct SignInButton {
        static let fontSize = 16.0
        static let letterSpacing = -0.13
    }
    
    static let textFieldTextSize = 12.0
    static let textFieldSpacing = -0.1
    static let legalTextFieldSpacing = -0.08
    static let legalTextFieldTextSize = 10.0
}

final class SignInViewController: BaseViewController {
    var signInAction: EmptyCallback?
    
    private let signInLabel: UILabel = {
        let label = UILabel()
        label.setText(L10n.signInText, withLetterSpacing: Constants.SignIn.letterSpacing)
        label.font = FontFamily.ProximaNova.bold.font(size: Constants.SignIn.fontSize)
        label.textColor = .white
        return label
    }()
    
    private let emailTextField: StreamingTextField = {
        let textField = StreamingTextField.styled()
        textField.placeholder = L10n.emailPlaceholder
        textField.attributedPlaceholder = NSAttributedString(
            string: L10n.emailPlaceholder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    private let passwordTextField: StreamingTextField = {
        let textField = StreamingTextField.styled()
        textField.setAttributedPlaceholder(L10n.passwordPlaceholder)
        textField.autocapitalizationType = .none
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let signInButton: UIButton = {
        let button = UIButton(type: .custom)
        button.StreamingStyleWhite()
        button.setAttributedTitleForAllStates(L10n.signInText,
                                              font: FontFamily.ProximaNova.bold.font(size: Constants.SignInButton.fontSize),
                                              kern: Constants.SignInButton.letterSpacing,
                                              foregroundColor: .black)
        
        button.isEnabled = false
        return button
    }()
    
    let signUpTextView: LinkedTextView = LinkedTextView(baseText: L10n.signUpText,
                                                        fontSize: Constants.textFieldTextSize,
                                                        letterSpacing: Constants.textFieldSpacing,
                                                        links: [L10n.signUpTextBold: URL(string: Constants.privacyPolicyURLString)])
    
    let legalTextView: LinkedTextView = LinkedTextView(baseText: L10n.legalText,
                                                       fontSize: Constants.legalTextFieldTextSize,
                                                       letterSpacing: Constants.legalTextFieldSpacing,
                                                       links: [L10n.legalTextTerms: URL(string: Constants.privacyPolicyURLString),
                                                               L10n.legalTextPrivacy: URL(string: Constants.privacyPolicyURLString)])
    
    // MARK: - Validation
    
    let inputValidator = LoginInputValidator()
    
    // MARK: - View setup
    
    override func viewDidAppear(_ animated: Bool) {
        // MARK: - stub
        super.viewDidAppear(animated)
        simulateLogin()
    }
    
    override func setupView() {
        view.addSubview(signInLabel)
        signInLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(146.0)
            make.leading.equalTo(40.5)
        }
        
        view.addSubview(emailTextField)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        emailTextField.delegate = self
        emailTextField.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(50.0)
            make.leading.equalTo(41.0)
            make.trailing.equalTo(-29.0)
            make.top.equalTo(signInLabel.snp.bottom).inset(-40.0)
        }
        
        view.addSubview(passwordTextField)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.delegate = self
        passwordTextField.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(emailTextField)
            make.leading.equalTo(emailTextField)
            make.trailing.equalTo(emailTextField)
            make.height.equalTo(emailTextField.snp.height)
            make.top.equalTo(emailTextField.snp.bottom).inset(-10.0)
        }
        
        view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(performSignIn(sender:)), for: .touchUpInside)
        signInButton.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(passwordTextField)
            make.leading.equalTo(passwordTextField)
            make.trailing.equalTo(passwordTextField)
            make.height.equalTo(passwordTextField.snp.height)
            make.top.equalTo(passwordTextField.snp.bottom).inset(-20.0)
        }
        
        view.addSubview(signUpTextView)
        signUpTextView.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(view)
            make.height.equalTo(15.0)
            make.leading.greaterThanOrEqualTo(signInButton.snp.leading)
            make.trailing.lessThanOrEqualTo(signInButton.snp.trailing)
            make.top.equalTo(signInButton.snp.bottom).inset(-10.0)
        }
        
        view.addSubview(legalTextView)
        legalTextView.snp.makeConstraints { (make) -> Void in
            make.top.greaterThanOrEqualTo(signUpTextView.snp.bottom).inset(20.0)
            make.height.equalTo(12.0)
            make.centerX.equalTo(signUpTextView)
            make.leading.greaterThanOrEqualTo(20.0)
            make.trailing.lessThanOrEqualTo(-20.0)
            make.bottom.equalTo(view.snp.bottom).inset(29.0 + view.safeAreaInsets.bottom)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard touches.contains(where: { $0 == emailTextField || $0 == passwordTextField }) == false else { return }
        UIResponder.currentResponder?.resignFirstResponder()
    }
    
    // MARK: - Actions
    
    @objc private func textFieldDidChange(_ sender: UITextField) {
        (sender == emailTextField) ? (inputValidator.email = sender.text) : (inputValidator.password = sender.text)
        signInButton.isEnabled = inputValidator.isValidEmail && inputValidator.isValidPassword
    }
    
    @objc private func performSignIn(sender: Any?) {
        do {
            try inputValidator.validate()
        } catch {
            handleInputError(error)
        }
        performSignIn()
    }
    
    // MARK: - Exit point
    
    private func performSignIn() {
        signInAction?()
    }
    
    // MARK: - Stub
    
    private func simulateLogin() {
        emailTextField.text = "email@mail.com"
        passwordTextField.text = "password"
        signInButton.isEnabled = true
    }
}

extension SignInViewController: UITextFieldDelegate {
    private func handleInputError(_ error: Error) {
        // MARK: TODO - Error handling
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.blue.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case emailTextField:
            textField.layer.borderColor = inputValidator.isValidEmail ? UIColor.white.cgColor : UIColor.red.cgColor
        case passwordTextField:
            textField.layer.borderColor = inputValidator.isValidPassword ? UIColor.white.cgColor : UIColor.red.cgColor
        default:
            return
        }
    }
}
