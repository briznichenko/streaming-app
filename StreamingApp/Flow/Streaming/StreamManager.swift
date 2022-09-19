//
//  StreamManager.swift
//  StreamingApp
//
//  Created by Andriy Briznichenko on 9/3/22.
//

import UIKit
import AVFoundation
import HaishinKit

final class StreamManager {
    static let shared = StreamManager()
    private (set) var streamURI = ""
    private (set) var streamKey = ""
    
    private init() {}
    
    func updatePath(_ path: String) {
        guard let url = URL(string: path) else { return }
        if let key = url.pathComponents.last, validateKey(key) {
            streamKey = key
        }
        streamURI = url.deletingLastPathComponent().absoluteString
    }
    
    // MARK: - Util
    private func validateKey(_ key: String) -> Bool {
        let keyPredicate = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z]{1,15}-[A-Z0-9a-z]{1,15}-[A-Z0-9a-z]{1,15}-[A-Z0-9a-z]{1,15}-[A-Z0-9a-z]{1,15}")
        return keyPredicate.evaluate(with: key)
    }
}
