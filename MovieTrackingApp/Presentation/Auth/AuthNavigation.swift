//
//  AuthNavigation.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 30.12.24.
//

import Foundation

protocol AuthNavigation: AnyObject {
    func showLogin()
    func showSignUp()
    func showHomeScreen()
}
