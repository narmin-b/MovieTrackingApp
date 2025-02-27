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

//final class AuthCoordinator: Coordinator {
//    weak var parentCoordinator: Coordinator?
//    weak var delegate: AuthCoordinatorDelegate?
//    var children: [Coordinator] = []
//    var navigationController: UINavigationController
//    private let window: UIWindow
//    
//    init(window: UIWindow, navigationController: UINavigationController) {
//        self.window = window
//        self.navigationController = navigationController
//    }
//    
//    deinit {
//        print("deinit auth")
//        parentCoordinator = nil
//    }
//    
//    func start() {
//        let controller = OnboardingViewController(viewModel: .init(navigation: self))
//        showController(vc: controller)
//    }
//}
//
//extension AuthCoordinator: AuthNavigation {
//    func showHomeScreen() {
//        print(#function)
//    }
//    
//    func showLogin() {
//        let vc = LoginViewController(viewModel: .init(navigation: self))
//        showController(vc: vc)
//    }
//    
//    func showSignUp() {
//        let vc = SignupViewController(viewModel: .init(navigation: self))
//        showController(vc: vc)
//    }
//
//    func didCompleteAuthentication() {
//        delegate?.authDidFinish()
//        parentCoordinator?.childDidFinish(self)
//    }
//
//    func popbackScreen() {
//        popControllerBack()
//    }
//    
//    func showLaunch() {
//        let vc = LaunchViewController(viewModel: .init(navigation: self))
//        showController(vc: vc)
//    }
//}

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
        // Already have weak references, so no need to nil them out here
    }
    
    func start() {
        let controller = OnboardingViewController(viewModel: .init(navigation: self))
        showController(vc: controller)
    }
    
    func childDidFinish(_ child: Coordinator) {
        if let index = children.firstIndex(where: { $0 === child }) {
            children.remove(at: index)
        }
    }
}

extension AuthCoordinator: AuthNavigation {
    func showHomeScreen() {
        print(#function)
    }
    
    func showLogin() {
        let vc = LoginViewController(viewModel: .init(navigation: self))
        showController(vc: vc)
    }
    
    func showSignUp() {
        let vc = SignupViewController(viewModel: .init(navigation: self))
        showController(vc: vc)
    }

    func didCompleteAuthentication() {
        // Important! First notify delegate, then clean up
        delegate?.authDidFinish()
        
        // Explicitly tell parent coordinator to remove this coordinator
        parentCoordinator?.childDidFinish(self)
    }

    func popbackScreen() {
        popControllerBack()
    }
    
    func showLaunch() {
        let vc = LaunchViewController(viewModel: .init(navigation: self))
        showController(vc: vc)
    }
}
