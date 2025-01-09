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
    
    func setInput(email: String, password: String) {
        model.password = password
        model.email = email
    }
        
    init(navigation: AuthNavigation) {
        self.navigation = navigation
    }
    
    func checkLogin() {
        requestCallback?(.loading)
        DispatchQueue.main.async {
            FirebaseHelper.auth.signIn(withEmail: self.model.email ?? "", password: self.model.password ?? "") { [weak self] authResult, error in
                guard let self = self else { return }
                self.requestCallback?(.loaded)
                if let error = error {
                    self.requestCallback?(.error(message: error.localizedDescription))
                }
                if (authResult?.user) != nil {
                    UserDefaultsHelper.setString(key: "email", value: self.model.email ?? "")

                    UserDefaultsHelper.setString(key: "username", value: authResult?.user.displayName ?? "")
                    self.requestCallback?(.success)
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
