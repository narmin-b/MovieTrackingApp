//
//  SeeAllItemsViewModel.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 19.12.24.
//

import Foundation

final class SeeAllItemsViewModel {
    enum ViewState {
        case loading
        case loaded
        case success
        case error(message: String)
    }
    
    var requestCallback : ((ViewState) -> Void?)?
}
