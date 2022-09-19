//
//  StreamingCoordinator.swift
//  StreamingApp
//
//  Created by Andriy Briznichenko on 6/29/22.
//

import Foundation
import OverlayContainer

final class StreamingCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    
    private weak var streamController: StreamingViewController?
    private weak var endStreamController: EndStreamViewController?
    var qrAction: EmptyCallback?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = StreamingViewController()
        streamController = vc
        
        vc.eventsAction = { [weak self] in
            self?.presentEventsController()
        }
        vc.productsAction = { [weak self] in
            self?.presentProductsController()
        }
        vc.dismissAction = { [weak self] in
            self?.presentFinishStreamController()
        }
        navigationController.setViewControllers([vc], animated: true)
    }
    
    private func presentEventsController() {
        let vc = EventsViewController()
        vc.viewFinderAction = { [weak self] in
            vc.dismiss(animated: false, completion: nil)
            self?.qrAction?()
        }
        
        if #available(iOS 15.0, *), let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            navigationController.present(vc, animated: true, completion: nil)
        } else {
            let containerController = OverlayContainerViewController()
            containerController.delegate = self
            containerController.viewControllers = [vc]
            navigationController.addChild(vc, in: navigationController.view)
            navigationController.present(containerController, animated: true, completion: nil)
        }
    }
    
    private func presentProductsController() {
        let vc = ProductsViewController()
        
        if #available(iOS 15.0, *), let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            navigationController.present(vc, animated: true, completion: nil)
        } else {
            let containerController = OverlayContainerViewController()
            containerController.delegate = self
            containerController.viewControllers = [vc]
            navigationController.addChild(vc, in: navigationController.view)
            navigationController.present(containerController, animated: true, completion: nil)
        }
    }
    
    private func presentFinishStreamController() {
        let vc = EndStreamViewController()
        vc.finishStreamAction = streamController?.stopStreamingAction
        
        let containerController = OverlayContainerViewController()
        containerController.delegate = self
        containerController.viewControllers = [vc]
        navigationController.addChild(vc, in: navigationController.view)
        endStreamController = vc
        navigationController.present(containerController, animated: true, completion: nil)
    }
    
    func showQRController(){
        qrAction?()
    }
}

extension StreamingCoordinator: OverlayContainerViewControllerDelegate {
    func overlayContainerViewController(_ containerViewController: OverlayContainerViewController, heightForNotchAt index: Int, availableSpace: CGFloat) -> CGFloat {
        let isEndStreamController = endStreamController != nil
        return isEndStreamController ? availableSpace * 0.38 : availableSpace * 0.65
    }
    
    func numberOfNotches(in containerViewController: OverlayContainerViewController) -> Int {
        return 1
    }
    
    func overlayContainerViewController(_ containerViewController: OverlayContainerViewController,
                                        scrollViewDrivingOverlay overlayViewController: UIViewController) -> UIScrollView? {
        return (overlayViewController as? StreamingTableViewController)?.tableView
    }
    
    func overlayContainerViewController(_ containerViewController: OverlayContainerViewController,
                                        shouldStartDraggingOverlay overlayViewController: UIViewController,
                                        at point: CGPoint,
                                        in coordinateSpace: UICoordinateSpace) -> Bool {
        guard let header = (overlayViewController as? StreamingTableViewController)?.headerBar else {
            return false
        }
        let convertedPoint = coordinateSpace.convert(point, to: header)
        return header.bounds.contains(convertedPoint)
    }
}
