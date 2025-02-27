//
//  AuthNavigation.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 30.12.24.
//

import Foundation

protocol AuthNavigation: AnyObject {
    func showLaunch()
    func showLogin()
    func showOnboarding()
    func showSignUp()
    func popbackScreen()
    func didCompleteAuthentication()
}
