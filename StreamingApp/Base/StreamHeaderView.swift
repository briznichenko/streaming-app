//
//  StreamHeaderView.swift
//  StreamingApp
//
//  Created by Andriy Briznichenko on 6/25/22.
//

import Foundation
import SnapKit
import UIKit

private struct Constants {
    static let titleFontSize = 14.0
    static let eventFontSize = 12.0
    static let viewersFontSize = 10.0
    static let statusFontSize = 8.0
}

struct StreamHeaderConfiguration {
    let title: String
    let streamIcon: UIImage
    let viewers: Int
}

final class StreamHeaderView: UIView {
    var configuration: StreamHeaderConfiguration?
    var status: StreamStatus = .offline {
        didSet {
            changeHeaderMode(status)
        }
    }
    
    private let streamImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = FontFamily.ProximaNova.bold.font(size: Constants.titleFontSize)
        label.numberOfLines = 0
        return label
    }()
    
    private let eventNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.font = FontFamily.ProximaNova.medium.font(size: Constants.eventFontSize)
        label.text = "eventNameLabel"
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = StreamingStatusLabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.font = FontFamily.ProximaNova.bold.font(size: Constants.statusFontSize)
        return label
    }()
    
    private let viewersLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.text = "0 viewers"
        label.font = FontFamily.ProximaNova.bold.font(size: Constants.viewersFontSize)
        return label
    }()
    
    init(_ frame: CGRect = .zero, configuration: StreamHeaderConfiguration) {
        super.init(frame: .zero)
        
        self.configuration = configuration
        self.setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .black
        
        addSubview(streamImageView)
        streamImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.equalTo(30.0)
            make.width.equalTo(30.0)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(streamImageView.snp.trailing).inset(-12.0)
        }
        
        addSubview(eventNameLabel)
        eventNameLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalTo(titleLabel)
        }

        addSubview(statusLabel)
        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-2.0)
            make.leading.equalTo(titleLabel)
        }

        addSubview(viewersLabel)
        viewersLabel.snp.makeConstraints { make in
            make.centerY.equalTo(statusLabel)
            make.leading.equalTo(statusLabel.snp.trailing).inset(-5.0)
        }
        
        titleLabel.text = configuration?.title
        status = .offline
        streamImageView.image = configuration?.streamIcon
    }
    
    private func changeHeaderMode(_ mode: StreamStatus) {
        statusLabel.text = mode.rawValue.uppercased()
        statusLabel.backgroundColor = mode.color
        statusLabel.textColor = mode == .live ? .white : .black
        
        viewersLabel.isHidden = mode != .live
        eventNameLabel.isHidden = mode == .offline
        
        if mode == .offline {
            statusLabel.snp.remakeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).inset(-2.0)
                make.leading.equalTo(titleLabel)
            }
        } else {
            statusLabel.snp.remakeConstraints { make in
                make.top.equalTo(streamImageView.snp.bottom).inset(-10.0)
                make.leading.equalTo(streamImageView)
            }
        }
    }
}
