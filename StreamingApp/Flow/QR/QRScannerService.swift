//
//  QRScannerService.swift
//  StreamingApp
//
//  Created by Andriy Briznichenko on 7/4/22.
//

import Foundation
import SnapKit
import UIKit
import AVFoundation


final class QRScannerService: NSObject {
    // MARK: Properties
    
    private lazy var captureSession = { AVCaptureSession() }()
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    // MARK: Output
    
    var onOutput: ((BarCodeOutput) -> Void)?
    
    // MARK: Public methods
    
    func generateVideoPreview() throws -> AVCaptureVideoPreviewLayer {
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            throw ServiceError.cameraNotFound
        }
        
        let input: AVCaptureInput
        
        do {
            input = try AVCaptureDeviceInput(device: captureDevice)
        } catch {
            /// do any specific handling of `inputError` if needed
            throw ServiceError.captureInput
        }
        let captureMetadataOutput = AVCaptureMetadataOutput()
        
        captureSession.addInput(input)
        captureSession.addOutput(captureMetadataOutput)
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.videoPreviewLayer = videoPreviewLayer
        return videoPreviewLayer
    }
    
    func startVideoCapture() {
        captureSession.startRunning()
    }
    
    func stopVideoCapture() {
        captureSession.stopRunning()
    }
    
    // MARK: Private methods
    
    private func handleMetadataCodeOutput(_ metadataObject: AVMetadataMachineReadableCodeObject) {
        guard
            let videoPreviewLayer = videoPreviewLayer,
            let barCodeObject = videoPreviewLayer.transformedMetadataObject(for: metadataObject)
        else { return }
        
        let output = BarCodeOutput(bounds: barCodeObject.bounds, title: metadataObject.stringValue)
        onOutput?(output)
    }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate
extension QRScannerService: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard
            let metadataObj = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
            metadataObj.type == AVMetadataObject.ObjectType.qr
        else { return }
        handleMetadataCodeOutput(metadataObj)
    }
}

// MARK: - Nested types

extension QRScannerService {
    enum ServiceError: Error {
        case cameraNotFound
        case captureInput
    }
 
    struct BarCodeOutput {
        let bounds: CGRect
        let title: String?
    }
}
