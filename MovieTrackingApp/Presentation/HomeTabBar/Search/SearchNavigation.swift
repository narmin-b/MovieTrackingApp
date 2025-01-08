//
//  SearchNavigation.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 08.01.25.
//

import Foundation

protocol SearchNavigation: AnyObject {
    func showDetails(mediaType: MediaType, id: Int)
}
