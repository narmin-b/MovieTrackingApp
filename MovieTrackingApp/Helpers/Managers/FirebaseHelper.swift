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

final class FirebaseHelper {
    static let shared = FirebaseHelper()
    private init() {}
    static let auth = Auth.auth()
    
    func createUserWithEmailUsername(email: String, username: String, password: String) {
        FirebaseHelper.auth.createUser(withEmail: email, password: password) { [weak self] authResult, error  in
            guard let self = self else { return }
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let user = authResult?.user else {
                print("User creation failed.")
                return
            }
            
            let usernameChangeRequest = user.createProfileChangeRequest()
            usernameChangeRequest.displayName = username
            usernameChangeRequest.commitChanges { error in
                if let error = error {
                    print("Error updating display name: \(error.localizedDescription)")
                } else {
                    print("User created successfully with username: \(username)")
                }
            }
        }
    }
}
