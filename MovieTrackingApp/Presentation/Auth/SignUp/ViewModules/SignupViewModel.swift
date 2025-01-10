//
//  SignupViewModel.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 30.12.24.
//

import Foundation

final class SignupViewModel {
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
    
    func createUser(email: String, password: String, username: String) {
        requestCallback?(.loading)
        FirebaseHelper.shared.createUserWithEmailUsername(email: email, username: username, password: password) { result in
            switch result {
            case .success(let field):
                switch field {
                case .loaded:
                    self.requestCallback?(.loading)
                case .success:
                    self.requestCallback?(.success)
                }
            case .failure(let error):
                let errorMessage = error.localizedDescription
                self.requestCallback?(.error(message: errorMessage))
            }

        }
    }
    
    func showLoginScreen() {
        navigation?.showLogin()
    }
    
    func startHomeScreen() {
        navigation?.showHomeScreen()
    }
}
