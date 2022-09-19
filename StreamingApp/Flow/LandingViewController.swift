//
//  ViewController.swift
//  StreamingApp
//
//  Created by Andriy Briznichenko on 6/21/22.
//

import UIKit
import SnapKit

private struct Constants {
    struct StreamingTitle {
        static let fontSize = 20.0
        static let letterSpacing = -0.16
    }
    
    struct titleLabel {
        static let fontSize = 16.0
        static let letterSpacing = -0.13
    }
    
    struct subtitleLabel {
        static let fontSize = 12.0
        static let letterSpacing = -0.1
    }
        
    struct scanQRButton {
        static let imagePadding = 5.0
    }
}

final class LandingViewController: BaseViewController {
    var signInAction: EmptyCallback?
    var scanQRAction: EmptyCallback?
    
    private let landingImageView: UIImageView = {
        return UIImageView(image:  Asset.Images.streamingSplash.image)
    }()
    
    private let StreamingTitle: UILabel = {
        let label = UILabel()
        label.font = FontFamily.ProximaNova.bold.font(size: Constants.StreamingTitle.fontSize)
        label.setText(L10n.landingTitleText, withLetterSpacing: Constants.StreamingTitle.letterSpacing)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private let StreamingTitleIcon: UIImageView = {
        return UIImageView(image:  Asset.Images.streamingIcon.image)
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = FontFamily.ProximaNova.bold.font(size: Constants.titleLabel.fontSize)
        label.setText(L10n.landingTitleLabelText, withLetterSpacing: Constants.titleLabel.letterSpacing)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = FontFamily.ProximaNova.bold.font(size:Constants.subtitleLabel.fontSize)
        label.setText(L10n.landingSubtitleText, withLetterSpacing: Constants.subtitleLabel.letterSpacing)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.textColor = Asset.Colors.streamingLightGray.color
        return label
    }()
    
    private let signInButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleForAllStates(L10n.landingSignInButtonText, foregroundColor: .black)
        button.StreamingStyleWhite()
        return button
    }()
    
    private let scanQRButton: UIButton = {
        let button = UIButton(type: .custom)
        button.StreamingStyle()
        
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.borderedTinted()
            if let font = button.titleLabel?.font {
                configuration.attributedTitle = AttributedString(L10n.landingScanButtonText, attributes: AttributeContainer([.font : font]))
            }
            configuration.baseForegroundColor = .white
            configuration.baseBackgroundColor = .black
            configuration.image = Asset.Images.qrImage.image
            configuration.imagePlacement = .trailing
            configuration.imagePadding = Constants.scanQRButton.imagePadding
            button.configuration = configuration
        } else {
            button.setTitleForAllStates(L10n.landingScanButtonText)
            button.backgroundColor = .black
            button.setImage(Asset.Images.qrImage.image, for: .normal)
            button.semanticContentAttribute = UIApplication.shared
                .userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
            button.imageEdgeInsets = UIEdgeInsets(top: 0,
                                                  left: Constants.scanQRButton.imagePadding,
                                                  bottom: 0,
                                                  right: 0)
        }
        
        return button
    }()
    
    override func setupView() {
        view.addSubview(landingImageView)
        landingImageView.snp.makeConstraints { (make) -> Void in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(80.0)
            make.height.equalTo(landingImageView.snp.width).multipliedBy(1.044)
        }
        
        let containerView = UIView()
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalTo(landingImageView)
            make.centerX.equalToSuperview()
        }
        
        containerView.addSubview(StreamingTitle)
        StreamingTitle.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        containerView.addSubview(StreamingTitleIcon)
        StreamingTitleIcon.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.equalTo(18.0)
            make.width.equalTo(20.5)
            make.trailing.equalTo(StreamingTitle.snp.leading)
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(view)
            make.width.equalTo(178.0)
            make.top.equalTo(landingImageView.snp.bottom).inset(-25.0).priority(1)
            make.leading.equalTo(view.snp.leading).inset(106).priority(2)
            make.trailing.equalTo(view.snp.trailing).inset(106).priority(2)
        }
        
        view.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(view)
            make.top.equalTo(titleLabel.snp.bottom).inset(-8.0)
            make.leading.equalTo(view.snp.leading).inset(56)
            make.trailing.equalTo(view.snp.trailing).inset(56)
        }
        
        view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(navigateToLogin(sender:)), for: .touchUpInside)
        signInButton.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(view)
            make.top.greaterThanOrEqualTo(subtitleLabel.snp.bottom).inset(-35.0)
            make.height.equalTo(50.0)
            make.width.equalTo(320.0)
        }
        
        view.addSubview(scanQRButton)
        scanQRButton.addTarget(self, action: #selector(navigateToQR(sender:)), for: .touchUpInside)
        scanQRButton.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(view)
            make.top.equalTo(signInButton.snp.bottom).inset(-10.0)
            make.height.equalTo(50.0)
            make.width.equalTo(320.0)
            make.bottom.equalTo(view.snp.bottom).inset(59.0)
        }
        
        view.sendSubviewToBack(landingImageView)
    }
    
    // MARK: - Navigation
    
    @objc private func navigateToLogin(sender: Any?) {
        signInAction?()
    }
    
    @objc private func navigateToQR(sender: Any?) {
        scanQRAction?()
    }
}
