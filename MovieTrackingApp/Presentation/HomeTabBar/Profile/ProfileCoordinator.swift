//
//  ProfileCoordinator.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 21.12.24.
//

import Foundation
import UIKit.UINavigationController

final class ProfileCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    private let window: UIWindow
    
    init(window: UIWindow, navigationController: UINavigationController) {
        self.window = window
        self.navigationController = navigationController
    }
    
    func start() {
        let controller = ProfileViewController(viewModel: ProfileViewModel(navigation: self))
        showController(vc: controller)
    }
}

extension ProfileCoordinator: ProfileNavigation {
    func showLaunchScreen() {
//        parentCoordinator?.children.removeAll()
//        
//        let authCoordinator = AuthCoordinator(navigationController: navigationController)
//        authCoordinator.parentCoordinator = parentCoordinator
//        parentCoordinator?.children.append(authCoordinator)
//
//        navigationController.setViewControllers([], animated: false)
//        
//        authCoordinator.start()
//        
//        parentCoordinator?.children.removeAll()
//        
//        let newNavigationController = UINavigationController()
//        let authCoordinator = AuthCoordinator(window: window, navigationController: newNavigationController)
//        authCoordinator.parentCoordinator = self
//        parentCoordinator?.children.append(authCoordinator)
//        
////        let window = UIWindow.current
////        window.rootViewController = newNavigationController
////        window.makeKeyAndVisible()
////        
//        authCoordinator.start()
//        
//        parentCoordinator?.childDidFinish(self)
        
        navigationController.delegate = nil
        parentCoordinator = nil
        navigationController.setViewControllers([], animated: true)
        children.removeAll()
        
        let vc = UINavigationController()
        let authCoordinator = AuthCoordinator(window: window, navigationController: vc)
        
        authCoordinator.parentCoordinator = self
        children.append(authCoordinator)
        authCoordinator.start()
        
        window.rootViewController = vc
        window.makeKeyAndVisible()
    }
}
