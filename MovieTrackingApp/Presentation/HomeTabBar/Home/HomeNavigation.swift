//
//  HomeNavigation.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 22.12.24.
//

import Foundation

enum MediaType: String {
    case movie
    case tvShow
}

protocol HomeNavigation: AnyObject {
    func showDetails(mediaType: MediaType, id: Int, nav: HomeNavigation)
    func showAllItems(listType: HomeListType)
    func popController()
}
