//
//  PermissionsViewController.swift
//  StreamingApp
//
//  Created by Andriy Briznichenko on 6/25/22.
//

import Foundation
import SnapKit
import UIKit
import AVFoundation

private struct Constants {
    static let permissionsLabelFontSize = 24.0
    static let permissionsLabelKern = -0.19
    
    static let fontSize = 14.0
}

final class PermissionsViewController: BaseViewController {
    var onDismiss: EmptyCallback?
    
    private let permissionsLabel: UILabel = {
        let label = UILabel()
        label.font = FontFamily.ProximaNova.bold.font(size: Constants.permissionsLabelFontSize)
        label.setText(L10n.permissionsLabelText, withLetterSpacing: Constants.permissionsLabelKern)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private let continueButton: UIButton = {
        let button = UIButton()
        button.setTitle(L10n.continueButtonTitle, for: .normal)
        button.StreamingStyleWhite()
        // MARK: - Stub
        button.setTitleColor(.gray, for: .disabled)
        button.isEnabled = false
        return button
    }()
    
    private let cameraSwitch: StreamingSwitch = {
        let configuration = StreamingSwitchConfiguration(title: L10n.cameraLabelText,
                                                    subtitle: L10n.cameraSubtitleLabelText,
                                                    icon: Asset.Images.cameraPermission.image)
        let switchView = StreamingSwitch(configuration: configuration)
        return switchView
    }()
    
    private let microphoneSwitch: StreamingSwitch = {
        let configuration = StreamingSwitchConfiguration(title: L10n.microphoneLabelText,
                                                    subtitle: L10n.microphoneSubtitleLabelText,
                                                    icon: Asset.Images.micPermission.image)
        let switchView = StreamingSwitch(configuration: configuration)
        return switchView
    }()
    
    // MARK: - View lifecycle
    
    override func setupView() {
        view.addSubview(permissionsLabel)
        permissionsLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(70.0 + UIApplication.statusBarHeight)
            make.centerX.equalToSuperview()
            make.leading.greaterThanOrEqualTo(80.0).priority(.medium)
            make.trailing.lessThanOrEqualTo(-80.0).priority(.medium)
            make.leading.greaterThanOrEqualTo(36.0).priority(.high)
            make.trailing.lessThanOrEqualTo(-49.0).priority(.high)
        }
        
        view.addSubview(cameraSwitch)
        cameraSwitch.addTarget(self, action: #selector(requestCameraAccess(sender:)), for: .valueChanged)
        cameraSwitch.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(permissionsLabel.snp.bottom).inset(-44.0)
            make.leading.equalTo(36.0)
            make.trailing.equalTo(-49.0)
        }
        
        view.addSubview(microphoneSwitch)
        microphoneSwitch.addTarget(self, action: #selector(requestMicrophoneAccess(sender:)), for: .valueChanged)
        microphoneSwitch.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(cameraSwitch.snp.bottom).inset(-18.0)
            make.leading.equalTo(36.0)
            make.trailing.equalTo(-49.0)
        }
        
        view.addSubview(continueButton)
        continueButton.addTarget(self, action: #selector(dismissController(sender:)), for: .touchUpInside)
        continueButton.snp.makeConstraints { (make) -> Void in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-28.0)
            make.width.equalTo(320.0)
            make.height.equalTo(50.0)
        }
        checkPermissions()
    }
    
    // MARK: - Permission Access
    
    private func checkPermissions() {
        cameraSwitch.isSelected = AVCaptureDevice.authorizationStatus(for: .video) == .authorized
        microphoneSwitch.isSelected = AVCaptureDevice.authorizationStatus(for: .audio) == .authorized
    }
    
    @objc private func requestCameraAccess(sender: Any?) {
        PermissionManager.resolvePermission(for: .camera, viewController: self) { status in
            DispatchQueue.main.async { [weak self] in
                self?.continueButton.isEnabled = PermissionManager.isMediaPermissionGranted
                self?.cameraSwitch.isSelected = status == .authorized
            }
        }
    }
    
    @objc private func requestMicrophoneAccess(sender: Any?) {
        PermissionManager.resolvePermission(for: .microphone, viewController: self) { status in
            DispatchQueue.main.async { [weak self] in
                self?.continueButton.isEnabled = PermissionManager.isMediaPermissionGranted
                self?.microphoneSwitch.isSelected = status == .authorized
            }
        }
    }
    
    // MARK: - Navigation
    
    @objc private func dismissController(sender: Any?) {
        onDismiss?()
    }
}


