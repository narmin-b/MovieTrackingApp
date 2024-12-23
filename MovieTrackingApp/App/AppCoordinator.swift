//
//  AppCoordinator.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 20.12.24.
//

import Foundation
import UIKit.UINavigationController

final class AppCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    var isLogin: Bool = true
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        if isLogin {
            showHome()
        } else {
            showAuth()
        }
    }
    
    fileprivate func showAuth() {
        children.removeAll()
//        let authCoordinator = AuthCoordinator(navigationController: navigationController)
//        children.append(authCoordinator)
//        authCoordinator.parentCoordinator = self
//        authCoordinator.start()
    }
    
    fileprivate func showHome() {
        children.removeAll()
        
        let homeTabBarCoordinator = HomeTabBarCoordinator(navigationController: navigationController)
        children.append(homeTabBarCoordinator)
        homeTabBarCoordinator.parentCoordinator = self
        homeTabBarCoordinator.start()
    }
}
