//
//  UIApplication+Extensions.swift
//  StreamingApp
//
//  Created by Andriy Briznichenko on 6/29/22.
//

import Foundation
import UIKit
import AVFoundation

extension UIApplication {
    static var statusBarHeight: CGFloat {
        return UIApplication.shared.connectedScenes
            .filter {$0.activationState == .foregroundActive }
            .map {$0 as? UIWindowScene }
            .compactMap { $0 }
            .first?.windows
            .filter({ $0.isKeyWindow }).first?
            .windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    }
}
