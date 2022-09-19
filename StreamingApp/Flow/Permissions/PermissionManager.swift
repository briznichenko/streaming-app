//
//  PermissionsManager.swift
//  StreamingApp
//
//  Created by Andriy Briznichenko on 7/10/22.
//

import Foundation
import AVFoundation
import UIKit

final class PermissionManager: NSObject {
    
    // MARK: - Properties
    
    static let shared = PermissionManager()
    
    static var isMediaPermissionGranted: Bool {
        return AVCaptureDevice.authorizationStatus(for: .video) == .authorized && AVCaptureDevice.authorizationStatus(for: .audio) == .authorized
    }
    
    // MARK: - Public methods
    
    public static func resolvePermission(for sourceType: PermissionType, viewController: UIViewController, completion: @escaping Callback<PermissionStatus>) {
        let resolver: PermissionResolver = {
            switch sourceType {
            case .microphone:
                return MicrophonePermissionResolver(viewController: viewController)
            case .camera:
                return CameraPermissionResolver(viewController: viewController)
            }
        }()
        
        resolver.resolvePermission(completion)
    }
    
    
    // MARK: - Private methods
    
    fileprivate func showPermissionDeniedAlert(for viewController: UIViewController, permissionType: PermissionType) {
        DispatchQueue.main.async(execute: {
            let alertController = UIAlertController(title: permissionType.title, message: permissionType.message, preferredStyle: .alert)
            
            let settingsAction = UIAlertAction(title: L10n.Alert.settings, style: .default, handler: { _ in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString),
                      UIApplication.shared.canOpenURL(settingsUrl) else {
                    return
                }
                UIApplication.shared.open(settingsUrl)
            })
            
            let cancelAction = UIAlertAction(title: L10n.Alert.notNow, style: .cancel, handler: nil)
            
            alertController.addAction(settingsAction)
            alertController.addAction(cancelAction)
            alertController.preferredAction = settingsAction
            viewController.present(alertController, animated: true)
        })
    }
}

// MARK: - Nested types

enum PermissionStatus {
    case authorized
    case denied
}

enum PermissionType {
    case microphone
    case camera
    
    var title: String {
        switch self {
        case .microphone:
            return L10n.Alert.Microphone.title(Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? "")
        case .camera:
            return L10n.Alert.Camera.title(Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? "")
        }
    }
    
    var message: String {
        switch self {
        case .microphone:
            return L10n.InfoPlist.nsMicrophoneUsageDescription
        case .camera:
            return L10n.InfoPlist.nsCameraUsageDescription
        }
    }
}

fileprivate protocol PermissionResolver {
    var viewController: UIViewController { get }
    func resolvePermission(_ callback: @escaping Callback<PermissionStatus>)
}

fileprivate extension PermissionManager {
    struct CameraPermissionResolver: PermissionResolver {
        unowned let viewController: UIViewController
        
        func resolvePermission(_ callback: @escaping Callback<PermissionStatus>) {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            switch status {
            case .authorized:
                callback(.authorized)
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { isAuthorized in
                    callback(isAuthorized ? .authorized : .denied)
                })
            default:
                PermissionManager.shared.showPermissionDeniedAlert(for: viewController, permissionType: .camera)
                callback(.denied)
            }
        }
    }
    
    struct MicrophonePermissionResolver: PermissionResolver {
        unowned let viewController: UIViewController
        
        func resolvePermission(_ callback: @escaping Callback<PermissionStatus>) {
            let status = AVCaptureDevice.authorizationStatus(for: .audio)
            switch status {
            case .authorized:
                callback(.authorized)
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .audio, completionHandler: { isAuthorized in
                    callback(isAuthorized ? .authorized : .denied)
                })
            default:
                PermissionManager.shared.showPermissionDeniedAlert(for: viewController, permissionType: .microphone)
                callback(.denied)
            }
        }
    }
}
