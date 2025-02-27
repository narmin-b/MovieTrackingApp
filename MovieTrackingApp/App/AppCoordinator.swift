////
////  AppCoordinator.swift
////  MovieTrackingApp
////
////  Created by Narmin Baghirova on 20.12.24.
////
//
import Foundation
import UIKit.UINavigationController
//
//final class AppCoordinator: Coordinator {
//    var parentCoordinator: Coordinator?
//    var children: [Coordinator] = []
//    var navigationController: UINavigationController
//    private let window: UIWindow
//    
//    private var isLogin: Bool = false
//    
//    init(window: UIWindow, navigationController: UINavigationController) {
//        self.window = window
//        self.navigationController = navigationController
//        setupObserver()
//    }
//    
//    private func setupObserver() {
//        NotificationCenter.default.addObserver(self, selector: #selector(listener), name: .sessionExpired, object: nil)
//    }
// 
//    func start() {
//        isLogin = UserDefaultsHelper.getBool(key: .isLoggedIn)
//        
//        if isLogin {
//            showHome()
//        } else {
//            showAuth()
//        }
//    }
//    
//    private func showAuth() {
//        children.removeAll()
//
//        // Clear the existing navigation stack
//        navigationController.viewControllers = []
//
//        let authCoordinator = AuthCoordinator(window: window, navigationController: navigationController)
//        authCoordinator.parentCoordinator = self
//        authCoordinator.delegate = self
//
//        children.append(authCoordinator)
//        authCoordinator.start()
//
//        window.rootViewController = navigationController
//        window.makeKeyAndVisible()
//    }
//
//    private func showHome() {
//        children.removeAll()
//
//        // Clear the existing navigation stack
//        navigationController.viewControllers = []
//
//        let homeCoordinator = HomeTabBarCoordinator(window: window, navigationController: navigationController)
//        homeCoordinator.parentCoordinator = self
//        children.append(homeCoordinator)
//        homeCoordinator.start()
//
//        window.rootViewController = navigationController
//        window.makeKeyAndVisible()
//    }
//    
////    private func showAuth() {
////        children.removeAll()
////        
////        let authCoordinator = AuthCoordinator(window: window, navigationController: navigationController)
////        authCoordinator.parentCoordinator = self
////        authCoordinator.delegate = self
////        
////        children.append(authCoordinator)
////        authCoordinator.start()
////        
////        window.rootViewController = nil
////        window.rootViewController = navigationController
////        window.makeKeyAndVisible()
////    }
////        
////    private func showHome() {
////        children.removeAll()
////        
////        let homeCoordinator = HomeTabBarCoordinator(window: window, navigationController: navigationController)
////        homeCoordinator.parentCoordinator = self
////        children.append(homeCoordinator)
////        homeCoordinator.start()
////        
////        window.rootViewController = nil
////        window.rootViewController = navigationController
////        window.makeKeyAndVisible()
////    }
//    
//    @objc private func listener() {
//        print(#function)
//        DispatchQueue.main.async {
//            self.showAuth()
//        }
//    }
//}
//
//extension AppCoordinator: AuthCoordinatorDelegate {
//    func authDidFinish() {
//        showHome()
//    }
//}

// AppCoordinator.swift

//final class AppCoordinator: Coordinator, AuthCoordinatorDelegate {
//    func authDidFinish() {
//        print("authDidFinish called!")
//            // First remove the auth coordinator from children
//            if let authCoord = children.first(where: { $0 is AuthCoordinator }) {
//                childDidFinish(authCoord)
//            }
//            // Then show home
//            showHome()
//    }
//    
//    var parentCoordinator: Coordinator?
//    var children: [Coordinator] = []
//    var navigationController: UINavigationController
//    private let window: UIWindow
//
//    private var isLogin: Bool = false
//    private var authCoordinator: AuthCoordinator?
//    private var homeCoordinator: HomeTabBarCoordinator?
//
//    init(window: UIWindow, navigationController: UINavigationController) {
//        self.window = window
//        self.navigationController = navigationController
//        setupObserver()
//    }
//
//    private func setupObserver() {
//        NotificationCenter.default.addObserver(self, selector: #selector(listener), name: .sessionExpired, object: nil)
//    }
//
//    func start() {
//        isLogin = UserDefaultsHelper.getBool(key: .isLoggedIn)
//
//        if isLogin {
//            showHome()
//        } else {
//            showAuth()
//        }
//    }
//
//    private func showAuth() {
//        // Clear the existing AuthCoordinator if it exists
//        authCoordinator?.parentCoordinator = nil
//        authCoordinator = nil
//        children.removeAll() // Remove all children coordinators
//
//        // Clear the navigation stack to avoid lingering view controllers
//        navigationController.viewControllers = []
//
//        authCoordinator = AuthCoordinator(window: window, navigationController: navigationController)
//        authCoordinator?.parentCoordinator = self
//        authCoordinator?.delegate = self
//
//        children.append(authCoordinator!)
//        authCoordinator?.start()
//
//        window.rootViewController = navigationController
//        window.makeKeyAndVisible()
//    }
//
//    private func showHome() {
//        // Clear the existing HomeTabBarCoordinator if it exists
//        homeCoordinator?.parentCoordinator = nil
//        homeCoordinator = nil
//        children.removeAll()
//
//        // Create a NEW navigation controller for the HomeTabBarCoordinator
//        let tabBarNavigationController = UINavigationController()
//        homeCoordinator = HomeTabBarCoordinator(
//            window: window,
//            navigationController: tabBarNavigationController // Pass NEW navigation controller
//        )
//
//        homeCoordinator?.parentCoordinator = self
//        children.append(homeCoordinator!)
//        homeCoordinator?.start()
//        
//        print("Before setting rootViewController, navigationController.viewControllers: \(navigationController.viewControllers)")
//
//        window.rootViewController = tabBarNavigationController // Pass the TabBarNavigationController
//        window.makeKeyAndVisible()
//    }
//
//    @objc private func listener() {
//        print(#function)
//        DispatchQueue.main.async {
//            self.showAuth()
//        }
//    }
//}

final class AppCoordinator: Coordinator, AuthCoordinatorDelegate {
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
        // Clean up existing coordinators
        children.forEach { child in
            childDidFinish(child)
        }
        
        // Clear references
        authCoordinator = nil
        homeCoordinator = nil
        
        // Clear the navigation stack
        navigationController.viewControllers = []

        // Create new auth coordinator
        let newAuthCoordinator = AuthCoordinator(window: window, navigationController: navigationController)
        newAuthCoordinator.parentCoordinator = self
        newAuthCoordinator.delegate = self
        
        authCoordinator = newAuthCoordinator
        children.append(newAuthCoordinator)
        newAuthCoordinator.start()

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

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
    
    private func showHome() {
        // Clean up existing coordinators
        children.forEach { child in
            childDidFinish(child)
        }

        // Clear references
        if let authCoord = authCoordinator { // Safely access authCoordinator
            authCoord.navigationController.viewControllers = [] // Clear AuthCoordinator's nav stack
        }
        authCoordinator = nil
        homeCoordinator = nil


        // Create a new navigation controller for the home flow
        let tabBarNavigationController = UINavigationController()

        // Create new home coordinator
        let newHomeCoordinator = HomeTabBarCoordinator(
            window: window,
            navigationController: tabBarNavigationController
        )

        newHomeCoordinator.parentCoordinator = self
        homeCoordinator = newHomeCoordinator
        children.append(newHomeCoordinator)
        newHomeCoordinator.start()

        // Set root view controller
        window.rootViewController = tabBarNavigationController
        window.makeKeyAndVisible()
    }

    func authDidFinish() {
        print("authDidFinish called!")
        showHome()
    }

    @objc private func listener() {
        print(#function)
        DispatchQueue.main.async {
            self.showAuth()
        }
    }
}
