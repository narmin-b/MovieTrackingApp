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
    private(set) var nowPlayingDto: NowPlayingMoviesList?
    private(set) var popularMoviesDto: PopularMoviesList?
    private(set) var topRatedMoviesDto: TopRatedMoviesList?
    private(set) var upcomingMoviesDto: UpcomingMoviesList?
    
    func getNowPlayingMovies() {
        requestCallback?(.loading)
        movieListsUse.getNowPlayingMovies { [weak self] dto, error in
            guard let self = self else { return }
            requestCallback?(.loading)
            if let dto = dto {
                nowPlayingDto = dto.results
                requestCallback?(.success)
            } else if let error = error {
                requestCallback?(.error(message: error))
            }
        }
    }
    
    func getNowPlayingItems() -> Int {
        return nowPlayingDto?.count ?? 0
    }
    
    func getNowPlayingProtocol(index: Int) -> TitleImageCellProtocol? {
        return nowPlayingDto?[index]
    }
        
    func getPopularMovies() {
        requestCallback?(.loading)
        movieListsUse.getPopularMovies { [weak self] dto, error in
            guard let self = self else { return }
            requestCallback?(.loading)
            if let dto = dto {
                popularMoviesDto = dto.results
                requestCallback?(.success)
            } else if let error = error {
                requestCallback?(.error(message: error))
            }
        }
    }
    
    func getPopularMovieItems() -> Int {
        return popularMoviesDto?.count ?? 0
    }
    
    func getPopularMovieProtocol(index: Int) -> TitleImageCellProtocol? {
        return popularMoviesDto?[index]
    }
    
    func getTopRatedMovies() {
        requestCallback?(.loading)
        movieListsUse.getTopRatedMovies { [weak self] dto, error in
            guard let self = self else { return }
            requestCallback?(.loading)
            if let dto = dto {
                print(dto)
                topRatedMoviesDto = dto.results
                requestCallback?(.success)
            } else if let error = error {
                requestCallback?(.error(message: error))
            }
        }
    }
    
    func getTopRatedItems() -> Int {
        return topRatedMoviesDto?.count ?? 0
    }
    
    func getTopRatedProtocol(index: Int) -> TitleImageCellProtocol? {
        return topRatedMoviesDto?[index]
    }
    
    func getUpcomingMovies() {
        requestCallback?(.loading)
        movieListsUse.getUpcomingMovies { [weak self] dto, error in
            guard let self = self else { return }
            requestCallback?(.loading)
            if let dto = dto {
                upcomingMoviesDto = dto.results
                requestCallback?(.success)
            } else if let error = error {
                requestCallback?(.error(message: error))
            }
        }
    }
    
    func getUpcomingItems() -> Int {
        return upcomingMoviesDto?.count ?? 0
    }
    
    func getUpcomingProtocol(index: Int) -> TitleImageCellProtocol? {
        return upcomingMoviesDto?[index]
    }
}
