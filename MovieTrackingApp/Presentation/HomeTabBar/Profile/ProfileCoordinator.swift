//
//  ProfileCoordinator.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 21.12.24.
//

import Foundation
import UIKit.UINavigationController

protocol ProfileCoordinatorDelegate: AnyObject {
    func homeTabBarDidFinish()
}

final class ProfileCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    weak var delegate: ProfileCoordinatorDelegate?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    private let window: UIWindow
    
    init(window: UIWindow, navigationController: UINavigationController) {
        self.window = window
        self.navigationController = navigationController
    }
    
    func start() {
        let controller = ProfileViewController(viewModel: ProfileViewModel(navigation: self))
        showController(vc: controller)
    }
}

extension ProfileCoordinator: ProfileNavigation {
    func showLaunchScreen() {
//        delegate?.homeTabBarDidFinish()
//        print(#function)
//        parentCoordinator?.childDidFinish(self)
        print("showLaunchScreen() called")

            if delegate == nil {
                print("⚠️ Delegate is nil!")
            } else {
                print("✅ Delegate exists, calling homeTabBarDidFinish()")
                delegate?.homeTabBarDidFinish()
            }

            parentCoordinator?.childDidFinish(self)
    }
}
