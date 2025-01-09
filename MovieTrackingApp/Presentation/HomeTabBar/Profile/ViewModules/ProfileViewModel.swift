//
//  ProfileViewModel.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 21.12.24.
//

import Foundation

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
}
