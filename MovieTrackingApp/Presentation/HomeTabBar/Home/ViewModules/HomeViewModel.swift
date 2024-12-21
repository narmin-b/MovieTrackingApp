//
//  HomeViewModel.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 19.12.24.
//

import Foundation

final class HomeViewModel {
    enum ViewState {
        case loading
        case loaded
        case success
        case error(message: String)
    }
    
    var requestCallback : ((ViewState) -> Void?)?
    
    // MARK: MovieLists Requests
    private var movieListsUse: MovieListsUseCase = MovieListsAPIService()
    private(set) var nowPlayingDto: NowPlayingDTO?
    private(set) var popularMoviesDto: PopularMoviesDTO?
    private(set) var topRatedMoviesDto: TopRatedMoviesDTO?
    private(set) var upcomingMoviesDto: UpcomingMoviesDTO?

    
    func getNowPlayingMovies() {
        requestCallback?(.loading)
        movieListsUse.getNowPlayingMovies { [weak self] dto, error in
            guard let self = self else { return }
            requestCallback?(.loading)
            if let dto = dto {
                nowPlayingDto = dto
                print(dto)
                requestCallback?(.success)
            } else if let error = error {
                requestCallback?(.error(message: error))
            }
        }
    }
    
    func getPopularMovies() {
        requestCallback?(.loading)
        movieListsUse.getPopularMovies { [weak self] dto, error in
            guard let self = self else { return }
            requestCallback?(.loading)
            if let dto = dto {
                popularMoviesDto = dto
//                print(dto)
                requestCallback?(.success)
            } else if let error = error {
                requestCallback?(.error(message: error))
            }
        }
    }
    
    func getTopRatedMovies() {
        requestCallback?(.loading)
        movieListsUse.getTopRatedMovies { [weak self] dto, error in
            guard let self = self else { return }
            requestCallback?(.loading)
            if let dto = dto {
                topRatedMoviesDto = dto
//                print(dto)
                requestCallback?(.success)
            } else if let error = error {
                requestCallback?(.error(message: error))
            }
        }
    }
    
    func getUpcomingMovies() {
        requestCallback?(.loading)
        movieListsUse.getUpcomingMovies { [weak self] dto, error in
            guard let self = self else { return }
            requestCallback?(.loading)
            if let dto = dto {
                upcomingMoviesDto = dto
//                print(dto)
                requestCallback?(.success)
            } else if let error = error {
                requestCallback?(.error(message: error))
            }
        }
    }
}
