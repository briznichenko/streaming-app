//
//  StreamingSwitch.swift
//  StreamingApp
//
//  Created by Andriy Briznichenko on 6/25/22.
//

import Foundation
import SnapKit
import UIKit

private struct Constants {
    static let labelFontSize = 14.0
    static let labelTextSpacing = -0.11
}

struct StreamingSwitchConfiguration {
    let title: String
    let subtitle: String
    let icon: UIImage
}

final class StreamingSwitch: UIControl {
    var configuration: StreamingSwitchConfiguration?
    
    private let switchView = UISwitch()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = FontFamily.ProximaNova.bold.font(size: Constants.labelFontSize)
        label.numberOfLines = 0
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Asset.Colors.streamingDarkGray.color
        label.font = FontFamily.ProximaNova.bold.font(size: Constants.labelFontSize)
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    init(_ frame: CGRect = .zero, configuration: StreamingSwitchConfiguration) {
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
        
        addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.leading.equalTo(self)
            make.height.equalTo(32.0)
            make.height.equalTo(32.0)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.leading.equalTo(iconImageView.snp.trailing).inset(-10.0)
        }
        
        addSubview(switchView)
        switchView.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.trailing.equalTo(self)
        }
        
        addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-5.0)
            make.leading.equalTo(titleLabel)
            make.bottom.greaterThanOrEqualTo(self)
            make.trailing.lessThanOrEqualTo(switchView.snp.leading).inset(-68.0).priority(.medium)
            make.trailing.lessThanOrEqualTo(switchView.snp.leading).inset(-20.0).priority(.high)
        }
        
        guard let configuration = self.configuration else { return }
        titleLabel.setText(configuration.title, withLetterSpacing: Constants.labelTextSpacing)
        subtitleLabel.setText(configuration.subtitle, withLetterSpacing: Constants.labelTextSpacing)
        iconImageView.image = configuration.icon
    }
    
    // MARK: - UIControl
    
    override func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        switchView.addTarget(target, action: action, for: controlEvents)
    }
    
    override var isSelected: Bool {
        get { return switchView.isSelected }
        set {
            switchView.isSelected = newValue
            switchView.isOn = newValue
        }
    }
    
}
