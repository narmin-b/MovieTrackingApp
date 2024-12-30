//
//  LoginViewModel.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 30.12.24.
//

import Foundation

final class LaunchViewModel {
    enum ViewState {
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
    
}
