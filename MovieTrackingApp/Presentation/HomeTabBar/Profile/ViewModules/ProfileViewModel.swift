//
//  ProfileViewModel.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 21.12.24.
//

import Foundation
import UIKit.UIImage

final class ProfileViewModel {
    enum ViewState {
        case loading
        case loaded
        case success
        case error(message: String)
    }
    
    var requestCallback: ((ViewState) -> Void)?
    private weak var navigation: ProfileNavigation?
    
    init(navigation: ProfileNavigation) {
        self.navigation = navigation
    }
    
    func showLaunchScreen() {
        navigation?.showLaunchScreen()
    }
    
    func loadProfilePictureFromDocuments() -> UIImage {
        requestCallback?(.loading)
        guard let fileNameWithExtension = UserDefaultsHelper.getString(key: "profileImage") else { return UIImage() }
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Failed to access the documents directory.")
            requestCallback?(.error(message: "Profile Picture Not Found"))
            return UIImage()
        }
        requestCallback?(.loaded)
        
        let fileURL = documentsDirectory.appendingPathComponent(fileNameWithExtension)
        
        requestCallback?(.success)
        return UIImage(contentsOfFile: fileURL.path) ?? UIImage()
    }
    
    func LogUserOut() {
        showLaunchScreen()
//        requestCallback?(.loading)
//        do {
//            try FirebaseHelper.auth.signOut()
//            requestCallback?(.success)
//        } catch let signOutError as NSError {
//            print ("Error signing out: %@", signOutError)
//            requestCallback?(.error(message: signOutError as! String))
//        }
//        requestCallback?(.loaded)
    }
}
