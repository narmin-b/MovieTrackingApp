//
//  SeeAllItemsViewModel.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 19.12.24.
//

import Foundation
import UIKit

enum ResultType {
    case movie(MovieResultDTO)
    case tvShow(TvShowResultDTO)
}

final class SeeAllItemsViewModel {
    enum ViewState {
        case loading
        case loaded
        case success
        case error(message: String)
    }
    
    var requestCallback : ((ViewState) -> Void?)?
    private weak var navigation: HomeNavigation?
    
    private var tvShowListsUse: TvShowListsUseCase = TvShowListsAPIService()
    private var movieListsUse: MovieListsUseCase = MovieListsAPIService()
    private var resultList: [ResultType] = []
    private var listType: HomeListType
    
    init(listType: HomeListType, navigation: HomeNavigation) {
        self.listType = listType
        self.navigation = navigation
    }
    
    func showMovieDetail(mediaType: MediaType, id: Int) {
        navigation?.showDetails(mediaType: mediaType, id: id, nav: navigation!)
    }
    
    func getAllItems() -> Int {
        return resultList.count
    }
    
    func getItem(index: Int) -> Int {
        let result = resultList[index]
        switch result {
        case .movie(let movieDTO):
            return movieDTO.id
        case .tvShow(let tvShowDTO):
            return tvShowDTO.id
        }
    }
    
    func getAllItemsProtocol(index: Int) -> TitleImageCellProtocol? {
        let result = resultList[index]
        switch result {
        case .movie(let movieDTO):
            return movieDTO
        case .tvShow(let tvShowDTO):
            return tvShowDTO
        }
    }
    
    func getNavBarTitle() -> String {
        switch listType {
        case .movie(let movie):
            switch movie {
            case .nowPlaying:
                return "Now Playing"
            case .popular:
                return "Popular"
            case .topRated:
                return "Top Rated"
            case .upcoming:
                return "Upcoming"
            }
        case .tvShow(let tvShow):
            switch tvShow{
            case .onTheAir:
                return "On The Air"
            case .popular:
                return "Popular"
            case .topRated:
                return "Top Rated"
            case .airingToday:
                return "Airing Today"
            }
        }
    }
    
    func getList() {
        switch listType {
        case .movie(let movie):
            switch movie {
            case .nowPlaying:
                getAllNowPlayingMovies()
            case .popular:
                getAllPopularMovies()
            case .topRated:
                getAllTopRatedMovies()
            case .upcoming:
                getAllUpcomingMovies()
            }
        case .tvShow(let tvShow):
            switch tvShow{
            case .onTheAir:
                getOnTheAirTvShows()
            case .popular:
                getPopularTvShows()
            case .topRated:
                getTopRatedTvShows()
            case .airingToday:
                getAiringTodayTvShows()
            }
        }
    }
    
    // MARK: Tv Show Lists Function
    
    fileprivate func getOnTheAirTvShows() {
        requestCallback?(.loading)
        for i in 1...10 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i-1) * 0.3) { [weak self] in
                guard let self = self else { return }
                self.tvShowListsUse.getOnTheAirTvShows(page: String(i)) { [weak self] dto, error in
                    guard let self = self else { return }
                    requestCallback?(.loaded)
                    if let dto = dto {
                        resultList += dto.results.map{ ResultType.tvShow($0) }
                        requestCallback?(.success)
                    } else if let error = error {
                        requestCallback?(.error(message: error))
                    }
                }
            }
        }
    }
    
    fileprivate func getPopularTvShows() {
        requestCallback?(.loading)
        for i in 1...10 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i-1) * 0.3) { [weak self] in
                guard let self = self else { return }
                self.tvShowListsUse.getPopularTvShows(page: String(i)) { [weak self] dto, error in
                    guard let self = self else { return }
                    requestCallback?(.loaded)
                    if let dto = dto {
                        resultList += dto.results.map{ ResultType.tvShow($0) }
                        requestCallback?(.success)
                    } else if let error = error {
                        requestCallback?(.error(message: error))
                    }
                }
            }
        }
    }
    
    fileprivate func getTopRatedTvShows() {
        requestCallback?(.loading)
        for i in 1...10 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i-1) * 0.3) { [weak self] in
                guard let self = self else { return }
                self.tvShowListsUse.getTopRatedTvShows(page: String(i)) { [weak self] dto, error in
                    guard let self = self else { return }
                    requestCallback?(.loaded)
                    if let dto = dto {
                        resultList += dto.results.map{ ResultType.tvShow($0) }
                        requestCallback?(.success)
                    } else if let error = error {
                        requestCallback?(.error(message: error))
                    }
                }
            }
        }
    }
    
    fileprivate func getAiringTodayTvShows() {
        requestCallback?(.loading)
        for i in 1...10 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i-1) * 0.3) { [weak self] in
                guard let self = self else { return }
                self.tvShowListsUse.getAiringTodayTvShows(page: String(i)) { [weak self] dto, error in
                    guard let self = self else { return }
                    requestCallback?(.loaded)
                    if let dto = dto {
                        resultList += dto.results.map{ ResultType.tvShow($0) }
                        requestCallback?(.success)
                    } else if let error = error {
                        requestCallback?(.error(message: error))
                    }
                }
            }
        }
    }
    
    // MARK: Movie Lists Functions
    
    fileprivate func getAllNowPlayingMovies() {
        requestCallback?(.loading)
        for i in 1...10 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i-1) * 0.3) { [weak self] in
                guard let self = self else { return }
                self.movieListsUse.getNowPlayingMovies(page: String(i)) { [weak self] dto, error in
                    guard let self = self else { return }
                    requestCallback?(.loaded)
                    if let dto = dto {
                        resultList += dto.results.map{ ResultType.movie($0) }
                        requestCallback?(.success)
                    } else if let error = error {
                        requestCallback?(.error(message: error))
                    }
                }
            }
        }
    }
    
    fileprivate func getAllPopularMovies() {
        requestCallback?(.loading)
        for i in 1...10 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i-1) * 0.3) { [weak self] in
                guard let self = self else { return }
                self.movieListsUse.getPopularMovies(page: String(i)) { [weak self] dto, error in
                    guard let self = self else { return }
                    requestCallback?(.loaded)
                    if let dto = dto {
                        resultList += dto.results.map{ ResultType.movie($0) }
                        requestCallback?(.success)
                    } else if let error = error {
                        requestCallback?(.error(message: error))
                    }
                }
            }
        }
    }

    fileprivate func getAllTopRatedMovies() {
        requestCallback?(.loading)
        for i in 1...10 {
            DispatchQueue.main.asyncAfter(deadline: .now()  + Double(i-1) * 0.3) { [weak self] in
                guard let self = self else { return }
                self.movieListsUse.getTopRatedMovies(page: String(i)) { [weak self] dto, error in
                    guard let self = self else { return }
                    requestCallback?(.loaded)
                    if let dto = dto {
                        resultList += dto.results.map{ ResultType.movie($0) }
                        requestCallback?(.success)
                    } else if let error = error {
                        requestCallback?(.error(message: error))
                    }
                }
            }
        }
    }
    
    fileprivate func getAllUpcomingMovies() {
        requestCallback?(.loading)
        for i in 1...10 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i-1) * 0.3) { [weak self] in
                guard let self = self else { return }
                self.movieListsUse.getUpcomingMovies(page: String(i)) { [weak self] dto, error in
                    guard let self = self else { return }
                    requestCallback?(.loaded)
                    if let dto = dto {
                        resultList += dto.results.map{ ResultType.movie($0) }
                        requestCallback?(.success)
                    } else if let error = error {
                        requestCallback?(.error(message: error))
                    }
                }
            }
        }
    }
}
