//
//  StreamingTableHeaderBar.swift
//  StreamingApp
//
//  Created by Andriy Briznichenko on 6/28/22.
//

import Foundation

import SnapKit
import UIKit

private struct Constants {
    static let collapseIndicatorOpacity: Float = 0.19
    static let collapseIndicatorCornerRadius = 2.0
    static let titleFontSize = 16.0
    static let subtitleFontSize = 12.0
}

final class StreamingTableHeaderBar: UIView {
    var backAction: EmptyCallback = {}
    var viewFinderAction: EmptyCallback?

    private let collapseIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = Constants.collapseIndicatorCornerRadius
        view.layer.opacity = Constants.collapseIndicatorOpacity
        return view
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = FontFamily.ProximaNova.bold.font(size: Constants.titleFontSize)
        label.textColor = .white
        return label
    }()
    
    var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = FontFamily.ProximaNova.bold.font(size: Constants.subtitleFontSize)
        label.textColor = Asset.Colors.streamingLightGray.color
        return label
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(Asset.Images.streamingBack.image, for: .normal)
        return button
    }()
    
    var viewfinderButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(Asset.Images.qrImage.image, for: .normal)
        return button
    }()
    
    private let bottomSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = Asset.Colors.separatorColor.color
        return view
    }()
    
    // MARK: - View setup
    
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
        addSubview(collapseIndicator)
        collapseIndicator.snp.makeConstraints { make in
            make.top.equalTo(9.0)
            make.centerX.equalToSuperview()
            make.height.equalTo(4.0)
            make.width.equalTo(30.0)
        }
        
        addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.leading.equalTo(32.0)
            make.top.equalTo(36.0)
            make.height.equalTo(32.0)
            make.width.equalTo(36.0)
        }
        
        addSubview(viewfinderButton)
        viewfinderButton.snp.makeConstraints { make in
            make.trailing.equalTo(-32.0)
            make.top.equalTo(backButton)
            make.height.equalTo(backButton)
            make.width.equalTo(backButton)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(backButton)
            make.centerX.equalToSuperview()
            make.leading.greaterThanOrEqualTo(backButton.snp.trailing)
            make.trailing.lessThanOrEqualTo(viewfinderButton.snp.leading)
        }
        
        addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-8.0)
            make.centerX.equalToSuperview()
            make.leading.greaterThanOrEqualTo(backButton.snp.trailing)
            make.trailing.lessThanOrEqualTo(viewfinderButton.snp.leading)
        }
        
        addSubview(bottomSeparator)
        bottomSeparator.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(1.0)
        }
        
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        viewfinderButton.addTarget(self, action: #selector(didTapViewFinderButton), for: .touchUpInside)
    }
    
    @objc private func didTapBackButton() {
        backAction()
    }
    
    @objc private func didTapViewFinderButton() {
        viewFinderAction?()
    }
}
