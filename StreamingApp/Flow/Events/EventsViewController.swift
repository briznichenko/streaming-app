//
//  EventsViewController.swift
//  StreamingApp
//
//  Created by Andriy Briznichenko on 6/29/22.
//

import Foundation
import UIKit

private struct Constants {
    static let placeholderFontSize = 12.0
    static let bottomButtonKern = -0.11
}

final class EventsViewController: StreamingTableViewController {
    var viewFinderAction: EmptyCallback?
    
    private var dataSource = EventsDataSource() {
        didSet {
            placeholderLabel.isHidden = dataSource.eventsCount > 0
        }
    }
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = FontFamily.ProximaNova.semibold.font(size: Constants.placeholderFontSize)
        label.textColor = .white
        label.text = L10n.eventsPlaceholderText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override func setupView() {
        super.setupView()
        
        headerBar.titleLabel.text = L10n.eventsTitleText
        bottomButton.titleLabel?.setText(L10n.eventsBottomButtonText, withLetterSpacing: Constants.bottomButtonKern)
        bottomButton.setAttributedTitle(bottomButton.titleLabel?.attributedText, for: .normal)
        headerBar.viewFinderAction = viewFinderAction
        tableView.dataSource = self
        
        view.addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints { make in
            make.top.equalTo(headerBar.snp.bottom).inset(-85.0)
            make.centerX.equalTo(tableView.snp.centerX)
            make.width.equalTo(198.0)
            make.height.equalTo(30.0)
        }
        placeholderLabel.isHidden = dataSource.eventsCount > 0
    }
}

extension EventsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.eventsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StreamingTableViewCell.reuseIdentifier, for: indexPath as IndexPath) as! StreamingTableViewCell
        cell.cellType = .event
        return cell
    }
}
