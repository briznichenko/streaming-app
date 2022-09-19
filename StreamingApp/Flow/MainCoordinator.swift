//
//  Coordinator.swift
//  StreamingApp
//
//  Created by Andriy Briznichenko on 6/29/22.
//

import Foundation
import OverlayContainer
import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var parentCoordinator: Coordinator? { get set }
    var navigationController: UINavigationController { get set }

    func start()
}

final class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var parentCoordinator: Coordinator? = nil
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = LandingViewController()
        vc.signInAction = { [weak self] in
            self?.showSignInController()
        }
        vc.scanQRAction = { [weak self] in
            self?.showQRController()
        }
        navigationController.pushViewController(vc, animated: false)
    }
    
    private func presentPermissionsControllerIfNeeded(completion: @escaping  EmptyCallback) {
        guard PermissionManager.isMediaPermissionGranted == false else {
            completion()
            return
        }
        let vc = PermissionsViewController()
        
        vc.onDismiss = {
            vc.dismiss(animated: true)
            completion()
        }
        navigationController.present(vc, animated: true)
    }

    private func showSignInController() {
        let vc = SignInViewController()
        vc.signInAction = { [weak self] in
            self?.showStreamingController()
        }
        navigationController.setViewControllers([vc], animated: true)
    }
    
    private func showQRController() {
        presentPermissionsControllerIfNeeded { [weak self] in
            let vc = QRViewController()
            vc.qrDetectedAction = { [weak self] in
                self?.showStreamingController()
            }
            vc.backAction = { [weak self] in
                self?.navigationController.popViewController(animated: true)
            }
            self?.navigationController.pushViewController(vc, animated: true)
        }
    }
    
    private func showStreamingController() {
        let coordinator = StreamingCoordinator(navigationController: navigationController)
        coordinator.qrAction = { [weak self] in
            self?.showQRController()
        }
        presentPermissionsControllerIfNeeded { [weak self] in
            self?.childCoordinators.append(coordinator)
            coordinator.parentCoordinator = self
            coordinator.start()
        }
    }
}
