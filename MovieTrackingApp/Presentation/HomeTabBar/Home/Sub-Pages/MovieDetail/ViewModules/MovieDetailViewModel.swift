//
//  MovieDetailViewModel.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 19.12.24.
//

import Foundation

final class MovieDetailViewModel {
    enum ViewState {
        case loading
        case loaded
        case success
        case error(message: String)
    }
    
    var requestCallback : ((ViewState) -> Void?)?
    private var movie: MovieDetailProtocol?
    
    init(movie: MovieDetailProtocol) {
        self.movie = movie
    }
    
    func getMovieName() -> String {
        return movie?.originalTitleStr ?? ""
    }
}
