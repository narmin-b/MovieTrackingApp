//
//  AuthCoordinator.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 30.12.24.
//

import Foundation
import UIKit.UINavigationController

protocol AuthCoordinatorDelegate: AnyObject {
    func authDidFinish()
}

final class AuthCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    weak var delegate: AuthCoordinatorDelegate?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    private let window: UIWindow
    
    init(window: UIWindow, navigationController: UINavigationController) {
        self.window = window
        self.navigationController = navigationController
    }
    
    deinit {
        print("AuthCoordinator deinit")
    }
    
    func start() {
        if UserDefaultsHelper.getBool(key: .hasCompletedOnboarding) {
            showLaunch()
        } else {
            showOnboarding()
        }
    }

    func childDidFinish(_ child: Coordinator) {
        if let index = children.firstIndex(where: { $0 === child }) {
            children.remove(at: index)
        }
    }
}

extension AuthCoordinator: AuthNavigation {
    func showLogin() {
        let vc = LoginViewController(viewModel: .init(navigation: self))
        showController(vc: vc)
    }
    
    func showSignUp() {
        let vc = SignupViewController(viewModel: .init(navigation: self))
        showController(vc: vc)
    }

    func didCompleteAuthentication() {
        delegate?.authDidFinish()
        
        parentCoordinator?.childDidFinish(self)
    }

    func popbackScreen() {
        popControllerBack()
    }
    
    func showOnboarding() {
        let vc = OnboardingViewController(viewModel: .init(navigation: self))
        showController(vc: vc)
    }
    
    func showLaunch() {
        let vc = LaunchViewController(viewModel: .init(navigation: self))
        showController(vc: vc)
    }
}
