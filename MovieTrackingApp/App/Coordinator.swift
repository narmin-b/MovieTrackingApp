//
//  Coordinator.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 20.12.24.
//

import Foundation
import UIKit.UINavigationController

protocol Coordinator: AnyObject {
    var parentCoordinator: Coordinator? { get set }
    var children: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}

extension Coordinator {
    func childDidFinish(_ child: Coordinator) {
        if let index = children.firstIndex(where: { $0 === child }) {
            children.remove(at: index)
        }
    }
    
    func showController(vc: UIViewController) {
        navigationController.show(vc, sender: nil)
    }
    
    func popControllerBack() {
        navigationController.popViewController(animated: true)
    }
    
    func deletePreviousController() {
        let viewCount = navigationController.viewControllers.count
        guard viewCount > 2 else { return }
        navigationController.viewControllers.remove(at: 1)
    }
}
