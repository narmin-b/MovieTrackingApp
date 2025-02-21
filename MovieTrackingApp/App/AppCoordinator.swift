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
        NotificationCenter.default.addObserver(self, selector: #selector(listener), name: .sessionExpired, object: nil)
    }
 
    func start() {
        isLogin = UserDefaultsHelper.getBool(key: .isLoggedIn)
        
        if isLogin {
            showHome()
        } else {
            showAuth()
        }
    }
    
    private func showAuth() {
        children.removeAll()
        
        let authCoordinator = AuthCoordinator(window: window, navigationController: navigationController)
        authCoordinator.parentCoordinator = self
        authCoordinator.delegate = self
        
        children.append(authCoordinator)
        authCoordinator.start()
        
        window.rootViewController = nil
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
        
    private func showHome() {
        children.removeAll()
        
        let homeCoordinator = HomeTabBarCoordinator(window: window, navigationController: navigationController)
        homeCoordinator.parentCoordinator = self
        children.append(homeCoordinator)
        homeCoordinator.start()
        
        window.rootViewController = nil
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    @objc private func listener() {
        print(#function)
        DispatchQueue.main.async {
            self.showAuth()
        }
    }
}

extension AppCoordinator: AuthCoordinatorDelegate {
    func authDidFinish() {
        showHome()
    }
}
