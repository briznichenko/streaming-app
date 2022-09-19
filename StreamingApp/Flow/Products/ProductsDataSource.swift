//
//  ProductsDataSource.swift
//  StreamingApp
//
//  Created by Andriy Briznichenko on 7/9/22.
//

import Foundation

// MARK: - Stub

final class ProductsDataSource {
    private var products = ["1", "2", "3"]
    
    var productsCount: Int {
        return products.count
    }
    
    func eventAt(index: Int) -> Any? {
        guard products.endIndex >= index, index >= products.startIndex else { return nil }
        return products[index]
    }
}
