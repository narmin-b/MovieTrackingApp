//
//  AuthCoordinator.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 30.12.24.
//

import Foundation
import UIKit.UINavigationController

final class AuthCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    deinit {
        print("deinit auth")
    }
    
    func start() {
        let controller = LaunchViewController(viewModel: .init(navigation: self))
        showController(vc: controller)
        
//        DispatchQueue.main.async {
//            self.parentCoordinator?.navigationController.viewControllers.removeFirst()
//        }
        print()
    }
}

extension AuthCoordinator: AuthNavigation {
    func showLogin() {
        let vc = LoginViewController(viewModel: .init(navigation: self))
        showController(vc: vc)
        deletePreviousController()
    }
    
    func showSignUp() {
        let vc = SignupViewController(viewModel: .init(navigation: self))
        showController(vc: vc)
        deletePreviousController()
    }
    
    func showHomeScreen() {
        parentCoordinator?.children.removeAll()
        
        let tabBar = HomeTabBarCoordinator(navigationController: navigationController)
        tabBar.parentCoordinator = self
        parentCoordinator?.children.append(tabBar)

        navigationController.setViewControllers([], animated: false)
        
        tabBar.start()
        
//        parentCoordinator?.children.removeAll()
//        
//        let newNavigationController = UINavigationController()
//        let tabBar = HomeTabBarCoordinator(navigationController: newNavigationController)
//        tabBar.parentCoordinator = parentCoordinator
//        parentCoordinator?.children.append(tabBar)
//        
//        let window = UIWindow.current
//        window.rootViewController = newNavigationController
//        window.makeKeyAndVisible()
//        
//        tabBar.start()
//        
//        parentCoordinator?.childDidFinish(self)
    }
    
    func popbackScreen() {
        popControllerBack()
    }
}
