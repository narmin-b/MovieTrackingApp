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
    
//    fileprivate func checkGuestSession() -> Bool {
//        let guestSessionUse: GuestSessionUseCase = GuestSessionAPIService()
//        var tokenCredentials: POSTSuccessProtocol?
//
////        "97b734804bc7ab2ae734a3b62db20"
//        guard let sessionID = UserDefaultsHelper.getString(key: .guestSessionID) else { return true }
//        var flag: Bool = false
//        guestSessionUse.checkGuestSessionExists(sessionID: sessionID) { [weak self] dto, error in
//            guard let _ = self else { return }
//            DispatchQueue.main.async {
//                if let dto = dto {
//                    tokenCredentials = dto.mapToDomain()
//                    print("token", tokenCredentials)
//                    if tokenCredentials?.success == true {
//                        print("token success")
//                        flag = true
////                        return
//                    } else {
//                        NotificationCenter.default.post(name: .sessionExpired, object: nil)
//                        flag = false
//                    }
//                } else if let _ = error {
//                    NotificationCenter.default.post(name: .sessionExpired, object: nil)
//                    flag = false
//                }
//            }
//        }
//        return flag
//    }
//    
    @objc private func listener() {
        print(#function)
        DispatchQueue.main.async {
            self.showAuth()
        }
    }
}
