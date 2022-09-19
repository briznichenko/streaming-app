//
//  StreamingTableViewCell.swift
//  StreamingApp
//
//  Created by Andriy Briznichenko on 6/28/22.
//

import Foundation
import UIKit
import SnapKit

private struct Constants {
    static let cellImageViewCornerRadius = 10.0
    static let selectionViewCornerRadius = 16.0
    static let separatorViewCornerRadius = 0.5
    static let imageViewCornerRadius = 10.0
    static let selectionViewBorderWidth = 2.0
    static let titleFontSize = 12.0
    static let subtitleFontSize = 10.0
    static let statusFontSize = 8.0
    static let statusLabelCornerRadius = 10.5
}

enum StreamingCellType: String {
    case event
    case product
}

struct StreamingCellConfiguration {
    let image: UIImage
    let title: String
    let subtitle: String
    let status: String?
}

final class StreamingTableViewCell: UITableViewCell {
    static let reuseIdentifier = "Streaming_cell"
    var configuration: StreamingCellConfiguration?
    var cellType: StreamingCellType = .event {
        didSet {
            statusLabel.isHidden = cellType != .event
        }
    }
    
    private let cellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = Constants.cellImageViewCornerRadius
        imageView.backgroundColor = .clear
        imageView.layer.cornerRadius = Constants.imageViewCornerRadius
        imageView.layer.borderWidth = Constants.selectionViewBorderWidth
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.clipsToBounds = true
        imageView.image = Asset.Images.productEventPlaceholder.image
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = FontFamily.ProximaNova.bold.font(size: Constants.titleFontSize)
        label.textColor = .white
        label.text = "Title"
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = FontFamily.ProximaNova.bold.font(size: Constants.subtitleFontSize)
        label.textColor = Asset.Colors.streamingLightGray.color
        label.text = "Subtitle"
        return label
    }()
    
    private let statusLabel: StreamingStatusLabel = {
        let label = StreamingStatusLabel()
        label.font = FontFamily.ProximaNova.bold.font(size: Constants.statusFontSize)
        label.layer.cornerRadius = Constants.statusLabelCornerRadius
        label.backgroundColor = Asset.Colors.streamingDarkGray.color
        label.textColor = Asset.Colors.streamingLightGray.color
        label.text = "scheduled".uppercased()
        return label
    }()
    
    private let selectionImageView: UIImageView = {
        return UIImageView(image: Asset.Images.checkCircle.image)
    }()
    
    private let selectionView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false
        view.layer.borderColor = UIColor.clear.cgColor
        view.layer.cornerRadius = Constants.selectionViewCornerRadius
        view.layer.borderWidth = Constants.selectionViewBorderWidth
        return view
    }()
    
    private let bottomSeparator: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constants.separatorViewCornerRadius
        view.backgroundColor = Asset.Colors.separatorColor.color
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        selectionStyle = .none
        backgroundColor = .black
        addSubview(selectionView)
        selectionView.snp.makeConstraints { make in
            make.top.equalTo(7.0)
            make.leading.equalTo(26.0)
            make.trailing.equalTo(-18.0)
            make.bottom.equalTo(-12.0)
        }
        
        selectionView.addSubview(cellImageView)
        cellImageView.snp.makeConstraints { make in
            make.leading.equalTo(6.0)
            make.top.equalTo(5.0)
            make.height.equalTo(50.0)
            make.width.equalTo(50.0)
        }
        
        selectionView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(cellImageView.snp.centerY)
            make.leading.equalTo(cellImageView.snp.trailing).inset(-14.0)
        }
        
        selectionView.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(cellImageView.snp.centerY)
            make.leading.equalTo(titleLabel)
        }
        
        selectionView.addSubview(statusLabel)
        statusLabel.snp.makeConstraints { make in
            make.centerY.equalTo(cellImageView.snp.centerY)
            make.trailing.equalTo(-7.0)
            make.width.equalTo(65.0)
            make.height.equalTo(20.0)
        }
        
        addSubview(selectionImageView)
        selectionImageView.snp.makeConstraints { make in
            make.centerY.equalTo(selectionView.snp.top).inset(5.0)
            make.leading.equalTo(26.0)
            make.width.equalTo(15.0)
            make.height.equalTo(15.0)
        }
        
        addSubview(bottomSeparator)
        bottomSeparator.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.bottom.equalToSuperview()
            make.height.equalTo(1.0)
        }
        
        statusLabel.isHidden = cellType != .event
        selectionImageView.isHidden = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionImageView.isHidden = selected == false
        let selectionView = cellType == .event ? selectionView : cellImageView
        selectionView.layer.borderColor = selected ? UIColor.blue.cgColor : UIColor.clear.cgColor
    }
}
