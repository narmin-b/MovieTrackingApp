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
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let controller = ProfileViewController(viewModel: ProfileViewModel(navigation: self))
        showController(vc: controller)
    }
}

extension ProfileCoordinator: ProfileNavigation {
    func showLaunchScreen() {
        parentCoordinator?.children.removeAll()
        
        let authCoordinator = AuthCoordinator(navigationController: navigationController)
        authCoordinator.parentCoordinator = parentCoordinator
        parentCoordinator?.children.append(authCoordinator)

        navigationController.setViewControllers([], animated: false)
        
        authCoordinator.start()
        
//        parentCoordinator?.children.removeAll()
//        
//        let newNavigationController = UINavigationController()
//        
//        parentCoordinator?.children.append(authCoordinator)
//        
//        let window = UIWindow.current
//        window.rootViewController = newNavigationController
//        window.makeKeyAndVisible()
//        
//        authCoordinator.start()
//        
//        parentCoordinator?.childDidFinish(self)
    }
}
