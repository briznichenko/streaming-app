//
//  SceneDelegate.swift
//  StreamingApp
//
//  Created by Andriy Briznichenko on 6/21/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let coordinator = MainCoordinator(navigationController: UINavigationController())

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        window?.isHidden = false
        
        window?.rootViewController = coordinator.navigationController
        coordinator.start()
    }
}

