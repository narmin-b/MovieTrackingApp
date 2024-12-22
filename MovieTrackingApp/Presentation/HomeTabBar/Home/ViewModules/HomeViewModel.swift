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
    private weak var navigation: HomeNavigation?
    private var seeAllList: [MovieResultDTO] = []

    
    init(navigation: HomeNavigation) {
        self.navigation = navigation
    }
    
    func showMovieDetail() {
        navigation?.showDetails()
    }
    
    func showAllItems(listType: MovieListType) {
        navigation?.showAllItems(listType: listType)
    }
    
    // MARK: MovieLists Requests
    
    private var movieListsUse: MovieListsUseCase = MovieListsAPIService()
    private(set) var nowPlayingDto: [MovieResultDTO] = []
    private(set) var popularMoviesDto: [MovieResultDTO] = []
    private(set) var topRatedMoviesDto: [MovieResultDTO] = []
    private(set) var upcomingMoviesDto: [MovieResultDTO] = []
    
    func getNowPlayingMovies() {
        requestCallback?(.loading)
        movieListsUse.getNowPlayingMovies(page: 1) { [weak self] dto, error in
            guard let self = self else { return }
            requestCallback?(.loaded)
            if let dto = dto {
                nowPlayingDto = dto.results
                requestCallback?(.success)
            } else if let error = error {
                requestCallback?(.error(message: error))
            }
        }
        print(nowPlayingDto)
    }
    
    func getNowPlayingItems() -> Int {
        return nowPlayingDto.count
    }
    
    func getNowPlayingProtocol(index: Int) -> TitleImageCellProtocol? {
        return nowPlayingDto[index]
    }
        
    func getPopularMovies() {
        requestCallback?(.loading)
        movieListsUse.getPopularMovies(page: 1) { [weak self] dto, error in
            guard let self = self else { return }
            requestCallback?(.loaded)
            if let dto = dto {
                popularMoviesDto = dto.results
                requestCallback?(.success)
            } else if let error = error {
                requestCallback?(.error(message: error))
            }
        }
    }
    
    func getPopularMovieItems() -> Int {
        return popularMoviesDto.count
    }
    
    func getPopularMovieProtocol(index: Int) -> TitleImageCellProtocol? {
        return popularMoviesDto[index]
    }
    
    func getTopRatedMovies() {
        requestCallback?(.loading)
        movieListsUse.getTopRatedMovies(page: 1) { [weak self] dto, error in
            guard let self = self else { return }
            requestCallback?(.loaded)
            if let dto = dto {
                topRatedMoviesDto = dto.results
                requestCallback?(.success)
            } else if let error = error {
                requestCallback?(.error(message: error))
            }
        }
    }
    
    func getTopRatedItems() -> Int {
        return topRatedMoviesDto.count
    }
    
    func getTopRatedProtocol(index: Int) -> TitleImageCellProtocol? {
        return topRatedMoviesDto[index]
    }
    
    func getUpcomingMovies() {
        requestCallback?(.loading)
        movieListsUse.getUpcomingMovies(page: 1) { [weak self] dto, error in
            guard let self = self else { return }
            requestCallback?(.loaded)
            if let dto = dto {
                upcomingMoviesDto = dto.results
                requestCallback?(.success)
            } else if let error = error {
                requestCallback?(.error(message: error))
            }
        }
    }
    
    func getUpcomingItems() -> Int {
        return upcomingMoviesDto.count
    }
    
    func getUpcomingProtocol(index: Int) -> TitleImageCellProtocol? {
        return upcomingMoviesDto[index]
    }
}
