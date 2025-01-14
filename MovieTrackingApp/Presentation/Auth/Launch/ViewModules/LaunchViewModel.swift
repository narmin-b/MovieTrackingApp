//
//  LoginViewModel.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 30.12.24.
//

import Foundation
import UIKit

final class LaunchViewModel {
    enum ViewState {
        case loading
        case loaded
        case success
        case error(message: String)
    }
    
    var requestCallback : ((ViewState) -> Void?)?
    private weak var navigation: AuthNavigation?
        
    init(navigation: AuthNavigation) {
        self.navigation = navigation
    }
    
    func showLoginController() {
        navigation?.showLogin()
    }
    
    func showSignupController() {
        navigation?.showSignUp()
    }
    
    func startHomeScreen() {
        navigation?.showHomeScreen()
    }
    
    func popBackScreen() {
        navigation?.popbackScreen()
    }
    
    
    func createUserWithGoogle(viewController: UIViewController) {
        requestCallback?(.loading)
        FirebaseHelper.shared.GoogleSignIn(viewController: viewController) { result in
            switch result {
            case .success(let field):
                switch field {
                case .loaded:
                    self.requestCallback?(.loaded)
                case .success:
                    self.requestCallback?(.success)
                case .successWithReturn(_):
                    return
                }
            case .failure(let error):
                let errorMessage = error.localizedDescription
                self.requestCallback?(.error(message: errorMessage))
            }
        }
    }
}
