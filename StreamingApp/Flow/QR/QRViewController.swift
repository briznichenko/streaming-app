//
//  QRViewController.swift
//  StreamingApp
//
//  Created by Andriy Briznichenko on 6/21/22.
//

import Foundation
import SnapKit
import UIKit
import AVFoundation

private struct Constants {
    static let fontSize = 14.0
    static let qrViewFinderCornerRadius = 40.0
    static let qrViewFinderBorderWidth = 3.0
}

final class QRViewController: BaseViewController {
    var backAction: EmptyCallback?
    var qrDetectedAction: EmptyCallback?
    
    private let backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(Asset.Images.streamingBack.image, for: .normal)
        return button
    }()
    
    private let qrLabel: UILabel = {
        let label = UILabel()
        label.font = FontFamily.ProximaNova.bold.font(size: Constants.fontSize)
        label.text = L10n.qrLabelText
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private let qrFinderView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = Constants.qrViewFinderCornerRadius
        view.layer.borderWidth = Constants.qrViewFinderBorderWidth
        view.layer.borderColor = UIColor.white.cgColor
        return view
    }()
    
    private let qrPromptLabel: UILabel = {
        let label = UILabel()
        label.font = FontFamily.ProximaNova.bold.font(size: Constants.fontSize)
        label.text = L10n.qrPromptText
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Scanner
    private let qrScannerService = QRScannerService()
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupQRScanner()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        videoPreviewLayer?.frame = view.layer.bounds
    }
    
    override func setupView(){
        
        view.addSubview(backButton)
        backButton.addTarget(self, action: #selector(backActionTriggered(sender:)), for: .touchUpInside)
        backButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(23.0 + UIApplication.statusBarHeight)
            make.leading.equalTo(34.0)
            make.height.equalTo(30.0)
            make.width.equalTo(30.0)
        }
        
        view.addSubview(qrLabel)
        qrLabel.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(backButton.snp.centerY)
            make.centerX.equalTo(view.snp.centerX)
        }
        
        view.addSubview(qrFinderView)
        qrFinderView.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(200.0)
            make.width.equalTo(qrFinderView.snp.height)
            make.centerX.equalTo(view)
            make.top.equalTo(qrLabel.snp.bottom).inset(-121.0)
        }
        
        view.addSubview(qrPromptLabel)
        qrPromptLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(qrFinderView.snp.bottom).inset(-27.0)
            make.centerX.equalTo(view.snp.centerX)
            make.leading.equalTo(qrFinderView.snp.leading)
            make.trailing.equalTo(qrFinderView.snp.trailing)
        }
        
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
    // MARK: - Scanner
    
    private func setupQRScanner() {
        let videoLayer: AVCaptureVideoPreviewLayer
        do {
            videoLayer = try qrScannerService.generateVideoPreview()
        } catch {
            // TODO: error handling
            return
        }
        
        qrScannerService.onOutput = { [weak self] outpt in
            self?.handleQRScannerOutput(outpt)
        }
        
        videoLayer.frame = view.layer.bounds
        view.layer.insertSublayer(videoLayer, at: 0)
        videoPreviewLayer = videoLayer
        qrScannerService.startVideoCapture()
    }
    
    private func handleQRScannerOutput(_ output: QRScannerService.BarCodeOutput) {
        qrFinderView.frame = output.bounds
        
        if let result = output.title {
            qrScannerService.stopVideoCapture()
            qrFinderView.layer.borderColor = UIColor.green.cgColor
            StreamManager.shared.updatePath(result)
            qrDetectedAction?()
        }
    }
    
    // MARK: - Actions
    
    @objc private func backActionTriggered(sender: Any?) {
        backAction?()
    }
}
