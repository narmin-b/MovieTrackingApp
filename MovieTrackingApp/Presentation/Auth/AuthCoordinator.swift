//
//  AuthCoordinator.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 30.12.24.
//

import Foundation
import UIKit.UINavigationController

final class AuthCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    private let window: UIWindow
    
    init(window: UIWindow, navigationController: UINavigationController) {
        self.window = window
        self.navigationController = navigationController
    }
    
    deinit {
        print("deinit auth")
        parentCoordinator = nil
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
        navigationController.delegate = nil
        parentCoordinator = nil
        navigationController.setViewControllers([], animated: true)
        children.removeAll()
        
        let vc = UINavigationController()
        let tabBar = HomeTabBarCoordinator(window: window, navigationController: vc)
        
        tabBar.parentCoordinator = self
        children.append(tabBar)
        tabBar.start()
        
        window.rootViewController = vc
        window.makeKeyAndVisible()
        
        //        parentCoordinator?.children.removeAll { $0 is AuthCoordinator }
//        if let index = children.firstIndex(where: { $0 is AuthCoordinator }) {
//                children.remove(at: index)
//            }
//        
////        parentCoordinator = nil
//        
//        navigationController.setViewControllers([], animated: false)
//        navigationController.delegate = nil
//        children.removeAll()
//        
//        let tabBar = HomeTabBarCoordinator(navigationController: navigationController)
//        tabBar.parentCoordinator = self
//        children.append(tabBar)
//        
//        tabBar.start()
//        
//        childDidFinish(self)
//        print("children \(parentCoordinator?.children)")

//        navigationController.setViewControllers([], animated: false)
//        children.removeAll()
//        
//        let tabBar = HomeTabBarCoordinator(navigationController: navigationController)
//        tabBar.parentCoordinator = self
//        children.append(tabBar)
//        
//        tabBar.start()
//        
//        childDidFinish(self)
    }
    
    func popbackScreen() {
        popControllerBack()
    }
}


//        navigationController.setViewControllers([], animated: false)
//
//        children.removeAll()
//
//        let newNavigationController = UINavigationController()
//        let tabBar = HomeTabBarCoordinator(window: window, navigationController: navigationController)
//        tabBar.parentCoordinator = self
//        children.append(tabBar)
//
//        window.rootViewController = newNavigationController
//        window.makeKeyAndVisible()
//
//        tabBar.start()
//
//        childDidFinish(self)
