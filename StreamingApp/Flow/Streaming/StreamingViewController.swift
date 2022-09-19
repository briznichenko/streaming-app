//
//  StreamingViewController.swift
//  StreamingApp
//
//  Created by Andriy Briznichenko on 6/25/22.
//

import Foundation
import SnapKit
import UIKit

// MARK: - Constants

private struct Constants {
    static let stubConfiguration = StreamHeaderConfiguration(title: "Brand Store Name", streamIcon: Asset.Images.brandPlaceholder.image, viewers: 0)
    static let eventsButtonFontSize = 14.0
    static let countDownLabelFontSize = 120.0
    static let countdownSeconds: UInt = 3
}

// MARK: - Internal types

enum StreamStatus: String {
    case offline = "offline"
    case ready = "ready"
    case live = "live"
    
    var color: UIColor {
        switch self {
        case .offline:
            return .white
        case .ready:
            return Asset.Colors.streamingGreen.color
        case .live:
            return Asset.Colors.streamingPink.color
        }
    }
}

final class StreamingViewController: BaseViewController {
    // MARK: - Actions
    
    var eventsAction: EmptyCallback?
    var productsAction: EmptyCallback?
    var dismissAction: EmptyCallback?
    var stopStreamingAction: EmptyCallback?
    
    // MARK: - CameraController
    
    private let streamController = StreamController()
    
    // MARK: - View
    
    private let headerView: StreamHeaderView = {
        let headerView = StreamHeaderView(configuration: Constants.stubConfiguration)
        return headerView
    }()
    
    private let countdownLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = FontFamily.ProximaNova.bold.font(size: Constants.countDownLabelFontSize)
        return label
    }()
    
    private let streamControlButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(Asset.Images.streamStart.image, for: .normal)
        button.setImage(Asset.Images.streamStarted.image, for: .selected)
        return button
    }()
    
    private let cameraOrientationButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(Asset.Images.cameraSwtich.image, for: .normal)
        button.setImage(Asset.Images.cameraSwitchToggled.image, for: .selected)
        return button
    }()
    
    private let micButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(Asset.Images.micToggle.image, for: .normal)
        button.setImage(Asset.Images.micToggled.image, for: .selected)
        return button
    }()
    
    private let eventsButton: UIButton = {
        let button = UIButton()
        button.StreamingStyle()
        button.layer.borderColor = UIColor.clear.cgColor
        button.backgroundColor = Asset.Colors.streamingDarkGray.color
        button.setTitleForAllStates(L10n.eventsButtonTitle,
                                    font: FontFamily.ProximaNova.bold.font(size: Constants.eventsButtonFontSize),
                                    foregroundColor: .white)
        return button
    }()
    
    private let productsButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(Asset.Images.productsButton.image, for: .normal)
        return button
    }()
    
    // MARK: - Popover controller
    
    private let backgroundView = UIView()
    
    // MARK: - View setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupView() {
        streamController.initialize(view: view)
        stopStreamingAction = { [weak self] in
            self?.viewState = .offline
            self?.streamController.stopCapture()
        }
        
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        view.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.equalTo(27.0 + UIApplication.statusBarHeight)
            make.leading.equalTo(37.0)
            make.trailing.equalTo(37.0)
        }
        
        view.addSubview(countdownLabel)
        countdownLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        view.addSubview(streamControlButton)
        streamControlButton.addTarget(self, action: #selector(toggleStream(sender:)), for: .touchUpInside)
        streamControlButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-21.0)
            make.height.equalTo(60.0)
            make.width.equalTo(60.0)
        }
        
        view.addSubview(cameraOrientationButton)
        cameraOrientationButton.addTarget(self, action: #selector(toggleCameraOrientation(sender:)), for: .touchUpInside)
        cameraOrientationButton.snp.makeConstraints { make in
            make.centerY.equalTo(streamControlButton.snp.centerY)
            make.trailing.equalTo(streamControlButton.snp.leading).inset(-20.0)
            make.height.equalTo(30.0)
            make.width.equalTo(30.0)
        }
        
        view.addSubview(micButton)
        micButton.addTarget(self, action: #selector(toggleMic(sender:)), for: .touchUpInside)
        micButton.snp.makeConstraints { make in
            make.centerY.equalTo(streamControlButton.snp.centerY)
            make.trailing.equalTo(cameraOrientationButton.snp.leading).inset(-20.0)
            make.height.equalTo(30.0)
            make.width.equalTo(30.0)
        }
        
        view.addSubview(eventsButton)
        eventsButton.addTarget(self, action: #selector(showEventsViewController(sender:)), for: .touchUpInside)
        eventsButton.snp.makeConstraints { make in
            make.trailing.equalTo(-25.0)
            make.bottom.equalTo(-36.0)
            make.width.equalTo(70.0)
            make.height.equalTo(30.0)
        }
        
        view.addSubview(productsButton)
        productsButton.addTarget(self, action: #selector(showProductsViewController(sender:)), for: .touchUpInside)
        productsButton.snp.makeConstraints { make in
            make.trailing.equalTo(eventsButton.snp.trailing)
            make.bottom.equalTo(eventsButton.snp.top).inset(-20.0)
            make.height.equalTo(50.0)
            make.width.equalTo(50.0)
        }
    }
    
    // MARK: - Streaming actions
    
    @objc private func toggleStream(sender: UIButton) {
        if streamController.isStreaming == true {
            showDismissalViewController(sender: streamControlButton)
        } else {
            viewState = .ready
            startCountdown { [weak self] in
                self?.streamController.startCapture()
                self?.viewState = .live
            }
        }
    }
    
    @objc private func toggleCameraOrientation(sender: UIButton) {
        streamController.toggleCameraPosition()
        sender.isSelected = streamController.isBackCameraOn
    }
    
    @objc private func toggleMic(sender: UIButton) {
        streamController.toggleMicrophone()
        sender.isSelected = !streamController.isMicrophoneOn
    }
    
    // MARK: - Streaming-related UI functions
    
    private var viewState: StreamStatus = .offline {
        didSet {
            headerView.status = viewState
            cameraOrientationButton.isHidden = viewState == .ready
            micButton.isHidden = viewState == .ready
            eventsButton.isHidden = viewState != .offline
            productsButton.isHidden = viewState == .ready
            switch viewState {
            case .offline:
                streamControlButton.isSelected = false
                productsButton.snp.remakeConstraints { make in
                    make.trailing.equalTo(eventsButton.snp.trailing)
                    make.bottom.equalTo(eventsButton.snp.top).inset(-20.0)
                    make.height.equalTo(50.0)
                    make.width.equalTo(50.0)
                }
            case .ready:
                streamControlButton.isSelected = true
                streamControlButton.isUserInteractionEnabled = false
            case .live:
                streamControlButton.isUserInteractionEnabled = true
                productsButton.snp.remakeConstraints { make in
                    make.trailing.equalTo(-25.0)
                    make.bottom.equalTo(-36.0)
                    make.height.equalTo(50.0)
                    make.width.equalTo(50.0)
                }
            }
        }
    }
    
    private func startCountdown(completion: @escaping EmptyCallback) {
        var secondsRemaining = Constants.countdownSeconds
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] (timer) in
            if secondsRemaining > 0 {
                self?.countdownLabel.text = "\(secondsRemaining)"
                secondsRemaining -= 1
            } else {
                self?.countdownLabel.text = ""
                timer.invalidate()
                completion()
            }
        }
    }
    
    @objc private func showEventsViewController(sender: Any?) {
        eventsAction?()
    }
    
    @objc private func showProductsViewController(sender: Any?) {
        productsAction?()
    }
    
    @objc private func showDismissalViewController(sender: Any?) {
        dismissAction?()
    }
}
