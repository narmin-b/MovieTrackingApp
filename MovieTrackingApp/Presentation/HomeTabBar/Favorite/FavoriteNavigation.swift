//
//  FavoriteNavigation.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 16.01.25.
//

import Foundation

protocol FavoriteNavigation: AnyObject {
    func showDetails(mediaType: MediaType, id: Int)
}
