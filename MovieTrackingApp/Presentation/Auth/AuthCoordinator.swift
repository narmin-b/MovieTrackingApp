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
    
    func start() {
        let controller = LaunchViewController(viewModel: .init(navigation: self))
        showController(vc: controller)
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
        let tabBar = HomeTabBarCoordinator(navigationController: navigationController)
        tabBar.parentCoordinator = self
        tabBar.parentCoordinator = nil
        children.append(tabBar)
        tabBar.start()
        childDidFinish(self)
    }
}
