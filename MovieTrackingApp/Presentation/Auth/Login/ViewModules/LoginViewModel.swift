//
//  LoginViewModel.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 30.12.24.
//

import Foundation

final class LoginViewModel {
    enum ViewState {
        case loading
        case loaded
        case success
        case error(message: String)
    }
    
    var requestCallback : ((ViewState) -> Void?)?
    private weak var navigation: AuthNavigation?
    
    private var model: UserDataModel = UserDataModel()
    
    func setInput(username: String, email: String) {
        model.username = username
        model.email = email
    }
        
    init(navigation: AuthNavigation) {
        self.navigation = navigation
    }
    
    func checkLogin(email: String, password: String) {
        requestCallback?(.loading)
        DispatchQueue.main.async {
            FirebaseHelper.auth.signIn(withEmail: email, password: password) { [weak self] authResult, error in
                guard let self = self else { return }
                self.requestCallback?(.loaded)
                if let error = error {
                    self.requestCallback?(.error(message: error.localizedDescription))
                    return
                }
                if (authResult?.user) != nil {
                    print(authResult?.user.displayName ?? "")
                    self.requestCallback?(.success)
                    return
                }
            }
        }
    }
    
    func startHomeScreen() {
        navigation?.showHomeScreen()
    }
    
    func showShowSignUpScreen() {
        navigation?.showSignUp()
    }
}
