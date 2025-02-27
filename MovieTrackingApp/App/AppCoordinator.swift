//
//  AppCoordinator.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 20.12.24.
//
//

import Foundation
import UIKit.UINavigationController

final class AppCoordinator: Coordinator, AuthCoordinatorDelegate, ProfileCoordinatorDelegate {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    private let window: UIWindow
    
    private var isLogin: Bool = false
    private var authCoordinator: AuthCoordinator?
    private var homeCoordinator: HomeTabBarCoordinator?
    
    init(window: UIWindow, navigationController: UINavigationController) {
        self.window = window
        self.navigationController = navigationController
        setupObserver()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("AppCoordinator deinit")
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
        if let homeCoord = homeCoordinator {
            homeCoord.cleanupChildren() 
            childDidFinish(homeCoord)
            homeCoordinator = nil
        }
        
        authCoordinator = nil
        homeCoordinator = nil

        navigationController.viewControllers = []

        window.rootViewController = nil

        let newAuthCoordinator = AuthCoordinator(
            window: window,
            navigationController: navigationController
        )
        
        newAuthCoordinator.parentCoordinator = self
        newAuthCoordinator.delegate = self
        authCoordinator = newAuthCoordinator
        children.append(newAuthCoordinator)
        newAuthCoordinator.start()

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    private func showHome() {
        if let authCoord = authCoordinator {
            childDidFinish(authCoord)
        }

        authCoordinator = nil
        homeCoordinator = nil

        navigationController.viewControllers = []
        navigationController.setNavigationBarHidden(true, animated: false)
        
        window.rootViewController = nil

        let newHomeCoordinator = HomeTabBarCoordinator(
            window: window,
            navigationController: navigationController
        )

        newHomeCoordinator.parentCoordinator = self
        newHomeCoordinator.delegate = self
        homeCoordinator = newHomeCoordinator
        children.append(newHomeCoordinator)
        newHomeCoordinator.start()

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    func authDidFinish() {
        print("authDidFinish called!")
        showHome()
    }
    
    func homeTabBarDidFinish() {
        print("homeTabBarDidFinish called!")
        showAuth()
    }

    @objc private func listener() {
        print(#function)
        DispatchQueue.main.async {
            self.showAuth()
        }
    }
}


//    private func showAuth() {
//        print("AppCoordinator::showAuth() - START (Simplified for Debugging)")
//
//        let authNavigationController = UINavigationController()
//        authNavigationController.setNavigationBarHidden(true, animated: false)
//
//        let newAuthCoordinator = AuthCoordinator(
//            window: window,
//            navigationController: authNavigationController
//        )
//        newAuthCoordinator.delegate = self // Make sure delegate IS set and uncommented
//        authCoordinator = newAuthCoordinator
//        children.append(newAuthCoordinator)
//
//        window.rootViewController = authNavigationController
//        window.makeKeyAndVisible()
//
//        newAuthCoordinator.start() // Start AFTER setting root view controller.
//        print("AppCoordinator::showAuth() - END (Simplified)")
//    }
//

//    private func showHome() {
//        // Clean up existing coordinators
//        children.forEach { child in
//            childDidFinish(child)
//        }
//
//        // Clear references
//        authCoordinator = nil
//        homeCoordinator = nil
//
//        // Create a new navigation controller for the home flow
//        let tabBarNavigationController = UINavigationController()
//
//        // Create new home coordinator
//        let newHomeCoordinator = HomeTabBarCoordinator(
//            window: window,
//            navigationController: tabBarNavigationController
//        )
//
//        newHomeCoordinator.parentCoordinator = self
//        homeCoordinator = newHomeCoordinator
//        children.append(newHomeCoordinator)
//        newHomeCoordinator.start()
//
//        // Set root view controller
//        window.rootViewController = tabBarNavigationController
//        window.makeKeyAndVisible()
//    }
    


// recent
//    private func showAuth() {
//        children.forEach { child in
//            childDidFinish(child)
//        }
//
//        if let homeCoord = homeCoordinator {
//            homeCoord.navigationController.viewControllers = []
//        }
//
//        authCoordinator = nil
//        homeCoordinator = nil
//
//        let authNavigationController = UINavigationController()
//        authNavigationController.setNavigationBarHidden(true, animated: false)
//
//        let newAuthCoordinator = AuthCoordinator(
//            window: window,
//            navigationController: authNavigationController
//        )
//
//        newAuthCoordinator.parentCoordinator = self
//        newAuthCoordinator.delegate = self
//        authCoordinator = newAuthCoordinator
//        children.append(newAuthCoordinator)
//
////        newAuthCoordinator.delegate = self
//
//        newAuthCoordinator.start()
//
//        window.rootViewController = authNavigationController
//        window.makeKeyAndVisible()
//    }
    
//    private func showHome() {
//        children.forEach { child in
//            childDidFinish(child)
//        }
//
//        if let authCoord = authCoordinator {
//            authCoord.navigationController.viewControllers = []
//        }
//        authCoordinator = nil
//        homeCoordinator = nil
//
//
//        let tabBarNavigationController = UINavigationController()
//        tabBarNavigationController.setNavigationBarHidden(true, animated: false)
//
//        let newHomeCoordinator = HomeTabBarCoordinator(
//            window: window,
//            navigationController: tabBarNavigationController
//        )
//
//        newHomeCoordinator.parentCoordinator = self
//
//        homeCoordinator = newHomeCoordinator
//        children.append(newHomeCoordinator)
//        newHomeCoordinator.delegate = self
//        newHomeCoordinator.start()
//
//        window.rootViewController = tabBarNavigationController
//        window.makeKeyAndVisible()
//    }
    
//private func showHome() {
//    children.forEach { child in
//        childDidFinish(child)
//    }
//
////        if let authCoord = authCoordinator {
////            authCoord.navigationController.viewControllers = []
////        }
//    authCoordinator = nil
//    homeCoordinator = nil
//
//    navigationController.viewControllers = []
//
////        let tabBarNavigationController = UINavigationController()
////        tabBarNavigationController.setNavigationBarHidden(true, animated: false)
//
//    let newHomeCoordinator = HomeTabBarCoordinator(
//        window: window,
//        navigationController: navigationController
//    )
//
//    newHomeCoordinator.parentCoordinator = self
//    newHomeCoordinator.delegate = self
//    homeCoordinator = newHomeCoordinator
//    children.append(newHomeCoordinator)
//    
//    newHomeCoordinator.start()
//
//    window.rootViewController = navigationController
//    window.makeKeyAndVisible()
//}
