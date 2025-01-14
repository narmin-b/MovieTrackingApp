//
//  FirebaseHelper.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 31.12.24.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import GoogleSignIn

enum SuccesType {
    case success
    case successWithReturn(String?)
    case loaded
}

final class FirebaseHelper {
    static let shared = FirebaseHelper()
    private init() {}
    static let auth = Auth.auth()
    
    func signInWithEmail(email: String, password: String, completion: @escaping (Result<SuccesType, Error>) -> Void) {
        FirebaseHelper.auth.signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let _ = self else { return }
            completion(.success(.loaded))
            if error != nil {
                completion(.failure(NSError(domain: "FirebaseLogInError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Server Error"])))
            }
            if (authResult?.user) != nil {
                completion(.success(.successWithReturn(authResult?.user.displayName)))
            }
        }
    }
    
    func createUserWithEmailUsername(email: String, username: String, password: String, completion: @escaping (Result<SuccesType, Error>) -> Void) {
        FirebaseHelper.auth.createUser(withEmail: email, password: password) { [weak self] authResult, error  in
            guard let _ = self else { return }
            completion(.success(.loaded))
            if let _ = error {
                completion(.failure(NSError(domain: "FirebaseSignInError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error reaching server"])))
                return
            }
            guard let user = authResult?.user else {
                completion(.failure(NSError(domain: "FirebaseSignInError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Error creating user"])))
                return
            }
            
            let usernameChangeRequest = user.createProfileChangeRequest()
            usernameChangeRequest.displayName = username
            usernameChangeRequest.commitChanges { error in
                if let _ = error {
                    completion(.failure(NSError(domain: "FirebaseSignInError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Error setting up username"])))
                } else {
                    completion(.success(.success))
                }
            }
        }
    }
    
    func GoogleSignIn(viewController: UIViewController, completion: @escaping (Result<SuccesType, Error>) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            completion(.failure(NSError(domain: "GoogleSignInError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Missing Client ID"])))
            return
        }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { [weak self] result, error in
            guard let _ = self else { return }
            completion(.success(.loaded))

            if let error = error {
                completion(.failure(error))
                return
            }

            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                completion(.failure(NSError(domain: "GoogleSignInError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to retrieve user info"])))
                return
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)

            FirebaseHelper.auth.signIn(with: credential) { authResult, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                if let user = authResult?.user {
                    UserDefaultsHelper.setString(key: "email", value: user.email ?? "")
                    UserDefaultsHelper.setString(key: "username", value: user.displayName ?? "")
                    completion(.success(.success))
                } else {
                    completion(.failure(NSError(domain: "GoogleSignInError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Authentication failed"])))
                }
            }
        }
    }
}
