//
//  CameraController.swift
//  StreamingApp
//
//  Created by Andriy Briznichenko on 7/9/22.
//

import Foundation
import AVFoundation
import UIKit

import HaishinKit
import VideoToolbox

private protocol StreamControllable {
    var isStreaming: Bool { get }
    var isMicrophoneOn: Bool { get }
    var isBackCameraOn: Bool { get }
    
    func initialize(view: UIView)
    func startCapture()
    func stopCapture()
    func toggleMicrophone()
    func toggleCameraPosition()
}

final class StreamController: StreamControllable {
    // MARK: - Stream
    private let rtmpConnection = RTMPConnection()
    private lazy var rtmpStream = RTMPStream(connection: rtmpConnection)

    private (set) var isStreaming = false
    var isMicrophoneOn: Bool { return rtmpStream.receiveAudio  }
    private (set) var isBackCameraOn: Bool = false
    
    private var hkView = HKView()
    
    func initialize(view: UIView) {
        hkView.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        applyDefaultSettings()
        rtmpStream.attachCamera(DeviceUtil.device(withPosition: .front)) { error in
            print(error)
        }
        rtmpStream.attachAudio(AVCaptureDevice.default(for: AVMediaType.audio),
                               automaticallyConfiguresApplicationAudioSession: false)

        view.insertSubview(hkView, at: 0)
        hkView.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        hkView.attachStream(rtmpStream)
    }
    
    // MARK: - Controls
    
    func startCapture() {
        rtmpConnection.connect(StreamManager.shared.streamURI)
        rtmpStream.publish(StreamManager.shared.streamKey)
        isStreaming = true
    }
    
    func stopCapture() {
        rtmpConnection.close()
        isStreaming = false
    }
    
    func toggleMicrophone() {
        rtmpStream.receiveAudio = !rtmpStream.receiveAudio
    }
    
    func toggleCameraPosition() {
        isBackCameraOn = !isBackCameraOn
        
        rtmpStream.attachCamera(DeviceUtil.device(withPosition: isBackCameraOn ? .back : .front)) { error in
            print(error)
        }
    }
    
    // MARK: - Utility
    
    private func applyDefaultSettings() {
        rtmpStream.captureSettings = [
            .fps: 30,
            .sessionPreset: AVCaptureSession.Preset.low,
            .preferredVideoStabilizationMode: AVCaptureVideoStabilizationMode.auto
        ]
        rtmpStream.audioSettings = [
            .muted: false,
            .bitrate: 32 * 1000,
        ]
        rtmpStream.videoSettings = [
            .width: 640,
            .height: 360,
            .bitrate: 160 * 1000,
            .profileLevel: kVTProfileLevel_H264_Baseline_3_1,
            .maxKeyFrameIntervalDuration: 2,
        ]
    }
}
