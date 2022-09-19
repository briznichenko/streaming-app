//
//  ProductsViewController.swift
//  StreamingApp
//
//  Created by Andriy Briznichenko on 6/29/22.
//

import Foundation
import UIKit

final class ProductsViewController: StreamingTableViewController {
    private let dataSource = ProductsDataSource()
    
    override func setupView() {
        super.setupView()
        
        headerBar.titleLabel.text = L10n.productsTitleText
        headerBar.subtitleLabel.text = L10n.productsSubtitleText
        headerBar.viewfinderButton.isHidden = true
        
        tableView.allowsMultipleSelection = true
        tableView.dataSource = self
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        
        let attributedString = NSAttributedString(string: L10n.productsBottomButtonTextSelected + " (\(tableView.indexPathsForSelectedRows?.count ?? 0))")
        bottomButton.setAttributedTitle(attributedString, for: .normal)
    }
    
    override func bottomButtonAction(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        sender.backgroundColor = sender.isSelected ? Asset.Colors.streamingDark.color : .white
        let attributedString = NSMutableAttributedString(string: (sender.isSelected ? L10n.productsBottomButtonText : L10n.productsBottomButtonTextSelected) + " (\(tableView.indexPathsForSelectedRows?.count ?? 0))",
                                  attributes: [.foregroundColor: sender.isSelected ? UIColor.white : UIColor.black])
        sender.setAttributedTitle(attributedString, for: .normal)
    }
}

extension ProductsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.productsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StreamingTableViewCell.reuseIdentifier, for: indexPath as IndexPath) as! StreamingTableViewCell
        cell.cellType = .product
        return cell
    }
}
