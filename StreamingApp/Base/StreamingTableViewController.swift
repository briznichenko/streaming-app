//
//  StreamingTableViewController.swift
//  StreamingApp
//
//  Created by Andriy Briznichenko on 6/25/22.
//

import UIKit
import SnapKit

private struct Constants {
    static let bottomButtonFont = 14.0
    static let rowHeight = 79.0
    static let viewCornerRadius = 19.0
}

class StreamingTableViewController: BaseViewController, UITableViewDelegate {
    var headerBar: StreamingTableHeaderBar = {
        let view = StreamingTableHeaderBar()
        return view
    }()
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .black
        tableView.rowHeight = Constants.rowHeight
        tableView.register(StreamingTableViewCell.self, forCellReuseIdentifier: StreamingTableViewCell.reuseIdentifier)
        return tableView
    }()
    
    var bottomButton: UIButton = {
        let button = UIButton()
        button.StreamingStyleWhite()
        button.titleLabel?.font = FontFamily.ProximaNova.bold.font(size: Constants.bottomButtonFont)
        button.setAttributedTitle(button.titleLabel?.attributedText, for: .normal)
        button.setTitleColor(.black, for: .selected)
        button.layer.borderColor = UIColor.clear.cgColor
        return button
    }()
    
    override func setupView() {
        view.layer.cornerRadius = Constants.viewCornerRadius
        view.layer.masksToBounds = true
        view.layer.isOpaque = false
        
        view.addSubview(headerBar)
        headerBar.snp.makeConstraints { make in
            make.height.equalTo(107.0)
            make.width.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        view.addSubview(bottomButton)
        bottomButton.addTarget(self, action: #selector(bottomButtonAction(sender:)), for: .touchUpInside)
        bottomButton.snp.makeConstraints { make in
            make.bottom.equalTo(-28.0)
            make.height.equalTo(50.0)
            make.leading.equalTo(37.0)
            make.trailing.equalTo(-33.0)
        }
        
        view.addSubview(tableView)
        view.sendSubviewToBack(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerBar.snp.bottom)
            make.width.equalToSuperview()
            make.bottom.equalTo(bottomButton.snp.top).inset(-28.0)
        }
        
        tableView.delegate = self
        headerBar.backAction = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
        
        bottomButton.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        bottomButton.isHidden = false
    }
    
    @objc func bottomButtonAction(sender: UIButton) {}
}
