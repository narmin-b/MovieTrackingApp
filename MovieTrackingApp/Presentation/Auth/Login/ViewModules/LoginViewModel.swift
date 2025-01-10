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
            FirebaseHelper.shared.signInWithEmail(email: self.model.email ?? "", password: self.model.password ?? "") { result in
                switch result {
                case .success(let field):
                    switch field {
                    case .loaded:
                        self.requestCallback?(.loaded)
                    case .success:
                        self.requestCallback?(.success)
                    case .successWithReturn(let username):
                        UserDefaultsHelper.setString(key: "username", value: username ?? "")
                        UserDefaultsHelper.setString(key: "email", value: self.model.email ?? "")
                        self.requestCallback?(.success)
                    }
                case .failure(let error):
                    let errorMessage = error.localizedDescription
                    self.requestCallback?(.error(message: errorMessage))
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
