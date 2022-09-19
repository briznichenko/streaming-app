//
//  BaseViewController.swift
//  StreamingApp
//
//  Created by Andriy Briznichenko on 6/25/22.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardNotificationObservers()
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardNotificationObservers()
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func setupView() {
        
    }
}
