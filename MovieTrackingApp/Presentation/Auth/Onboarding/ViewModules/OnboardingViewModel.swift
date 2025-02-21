//
//  OnboardingViewModel.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 05.02.25.
//

import Foundation
import UIKit

final class OnboardingViewModel {
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
    
    func showLaunchController() {
        navigation?.showLaunch()
    }
    
    func popBackScreen() {
        navigation?.popbackScreen()
    }
}
