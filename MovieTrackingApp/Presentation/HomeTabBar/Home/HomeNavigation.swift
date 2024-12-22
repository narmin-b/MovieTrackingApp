//
//  HomeNavigation.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 22.12.24.
//

import Foundation

protocol HomeNavigation: AnyObject {
    func showDetails()
    func showAllItems(listType: MovieListType)
}
