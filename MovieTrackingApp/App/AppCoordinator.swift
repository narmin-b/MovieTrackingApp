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
    private let window: UIWindow
    
    private var isLogin: Bool = false
    
    init(window: UIWindow, navigationController: UINavigationController) {
        self.window = window
        self.navigationController = navigationController
        setupObserver()
    }
    
    private func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(listener), name: NSNotification.Name("auth.session.exp"), object: nil)
    }
    
//    deinit {
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("auth.session.exp"), object: nil)
//    }
    
    func start() {
        isLogin = UserDefaultsHelper.getBool(key: "isLoggedIn")
        if isLogin {
            showHome()
        } else {
            showAuth()
        }
    }
    
    fileprivate func showAuth() {
        navigationController.setViewControllers([], animated: true)
        children.removeAll()

        let authCoordinator = AuthCoordinator(window: window, navigationController: navigationController)
        authCoordinator.parentCoordinator = self
        children.append(authCoordinator)
        authCoordinator.start()
    }
    
    fileprivate func showHome() {
        navigationController.setViewControllers([], animated: true)
        
        children.removeAll()

        let homeTabBarCoordinator = HomeTabBarCoordinator(window: window, navigationController: navigationController)
        homeTabBarCoordinator.parentCoordinator = self
        children.append(homeTabBarCoordinator)
        homeTabBarCoordinator.start()
    }
    
    @objc private func listener() {
        print(#function)
        DispatchQueue.main.async {
            self.showHome()
        }
    }
}
