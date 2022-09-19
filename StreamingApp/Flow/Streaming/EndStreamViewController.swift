//
//  EndStreamViewController.swift
//  StreamingApp
//
//  Created by Andriy Briznichenko on 6/28/22.
//

import Foundation
import UIKit
import SnapKit

private struct Constants {
    static let viewCornerRadius = 19.0
    static let titleFontSize = 24.0
    static let subtitleFontSize = 12.0
    static let buttonFontSize = 16.0
    static let buttonKern = -0.13
}

final class EndStreamViewController: BaseViewController {
    var finishStreamAction: EmptyCallback?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = FontFamily.ProximaNova.bold.font(size: Constants.titleFontSize)
        label.textColor = .white
        label.text = L10n.endStreamTitleText
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = FontFamily.ProximaNova.bold.font(size: Constants.subtitleFontSize)
        label.textColor = Asset.Colors.streamingLightGray.color
        label.text = L10n.endStreamSubtitleText
        return label
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = FontFamily.ProximaNova.bold.font(size: Constants.buttonFontSize)
        button.titleLabel?.setText(L10n.endStreamCancelText, withLetterSpacing: Constants.buttonKern)
        button.setAttributedTitle(button.titleLabel?.attributedText, for: .normal)
        button.StreamingStyleWhite()
        return button
    }()
    
    private let dismissButton: UIButton = {
        let button = UIButton(type: .custom)
        button.StreamingStyle()
        button.layer.borderColor = UIColor.clear.cgColor
        button.titleLabel?.font = FontFamily.ProximaNova.bold.font(size: Constants.buttonFontSize)
        button.titleLabel?.setText(L10n.endStreamText, withLetterSpacing: Constants.buttonKern)
        button.setAttributedTitle(button.titleLabel?.attributedText, for: .normal)
        button.backgroundColor = Asset.Colors.streamingDarkGray.color
        return button
    }()
    
    override func setupView() {
        view.layer.cornerRadius = Constants.viewCornerRadius
        view.layer.masksToBounds = true
        view.layer.isOpaque = false
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(31.0)
            make.centerX.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
        }
        
        view.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.centerX.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
        }
        
        view.addSubview(cancelButton)
        cancelButton.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
        cancelButton.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(view)
            make.top.equalTo(subtitleLabel.snp.bottom).inset(-36.0)
            make.height.equalTo(50.0)
            make.width.equalTo(320.0)
        }
        
        view.addSubview(dismissButton)
        dismissButton.addTarget(self, action: #selector(finishStream), for: .touchUpInside)
        dismissButton.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(view)
            make.top.equalTo(cancelButton.snp.bottom).inset(-10.0)
            make.height.equalTo(50.0)
            make.width.equalTo(320.0)
            make.bottom.lessThanOrEqualTo(view.snp.bottom).inset(-59.0)
        }
    }
    
    @objc private func dismissController(){
        dismiss(animated: true)
    }
    
    @objc private func finishStream() {
        dismiss(animated: true, completion: { [weak self] in
            self?.finishStreamAction?()
        })
    }
}
