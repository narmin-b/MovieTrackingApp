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
    
    private var movieListsUse: MovieListsUseCase = MovieListsAPIService()
    private var movieList: [MovieResultDTO] = []
    private var listType: MovieListType
    
    init(listType: MovieListType) {
        self.listType = listType
    }
    
//    func showMovieDetail() {
//        navigation?.showDetails()
//    }
    
    func getAllItems() -> Int {
        return movieList.count
    }
    
    func getAllItemsProtocol(index: Int) -> TitleImageCellProtocol? {
        return movieList[index]
    }
    
    func getNavBarTitle() -> String {
        switch listType {
        case .nowPlaying:
            return "Now Playing"
        case .popular:
            return "Popular"
        case .topRated:
            return "Top Rated"
        case .upcoming:
            return "Upcoming"
        }
    }
    
    func getList() {
        switch listType {
        case .nowPlaying:
            getAllNowPlayingMovies()
        case .popular:
            getAllPopularMovies()
        case .topRated:
            getAllTopRatedMovies()
        case .upcoming:
            getAllUpcomingMovies()
        }
    }
    
    fileprivate func getAllNowPlayingMovies() {
        requestCallback?(.loading)
        for i in 1...10 {
            movieListsUse.getNowPlayingMovies(page: i) { [weak self] dto, error in
                guard let self = self else { return }
                requestCallback?(.loaded)
                if let dto = dto {
                    movieList += dto.results
                } else if let error = error {
                    requestCallback?(.error(message: error))
                }
            }
        }
        requestCallback?(.success)
    }
    
    fileprivate func getAllPopularMovies() {
        requestCallback?(.loading)
        for i in 1...10 {
            self.movieListsUse.getPopularMovies(page: i) { [weak self] dto, error in
                guard let self = self else { return }
                requestCallback?(.loaded)
                if let dto = dto {
                    movieList += dto.results
                } else if let error = error {
                    requestCallback?(.error(message: error))
                }
            }
        }
        requestCallback?(.success)
    }

    fileprivate func getAllTopRatedMovies() {
        requestCallback?(.loading)
        for i in 1...10 {
            self.movieListsUse.getTopRatedMovies(page: i) { [weak self] dto, error in
                guard let self = self else { return }
                requestCallback?(.loaded)
                if let dto = dto {
                    movieList += dto.results
                } else if let error = error {
                    requestCallback?(.error(message: error))
                }
            }
        }
        requestCallback?(.success)
    }
    
    fileprivate func getAllUpcomingMovies() {
        requestCallback?(.loading)
        for i in 1...10 {
            self.movieListsUse.getUpcomingMovies(page: i) { [weak self] dto, error in
                guard let self = self else { return }
                requestCallback?(.loaded)
                if let dto = dto {
                    movieList += dto.results
                } else if let error = error {
                    requestCallback?(.error(message: error))
                }
            }
        }
        requestCallback?(.success)
    }
    
}
