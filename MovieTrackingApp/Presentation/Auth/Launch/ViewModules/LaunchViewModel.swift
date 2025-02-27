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
    private var guestSessionUse: GuestSessionUseCase = GuestSessionAPIService()
    private(set) var tokenCredentials: GuestSessionProtocol?
        
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
        navigation?.didCompleteAuthentication()
    }
    
    func popBackScreen() {
        navigation?.popbackScreen()
    }
    
    func createGuestSessionToken() {
        guestSessionUse.createGuestSessiontoken { [weak self] dto, error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let dto = dto {
                    self.tokenCredentials = dto.mapToDomain()
                    UserDefaultsHelper.setString(key: .guestSessionID, value: self.tokenCredentials?.guestSessionID ?? "")
                    self.requestCallback?(.success)
                } else if let error = error {
                    self.requestCallback?(.error(message: error))
                }
            }
        }
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
                    self.createGuestSessionToken()
//                    self.requestCallback?(.success)
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
