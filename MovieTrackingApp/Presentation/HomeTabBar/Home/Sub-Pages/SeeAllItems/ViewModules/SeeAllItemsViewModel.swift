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
        case morePageLoading
        case morePageLoaded
        case error(message: String)
    }
    
    var requestCallback : ((ViewState) -> Void?)?
    private weak var navigation: HomeNavigation?
    
    private var tvShowListsUse: TvShowListsUseCase = TvShowListsAPIService()
    private var movieListsUse: MovieListsUseCase = MovieListsAPIService()
    private var resultList: [ResultType] = []
    private var listType: HomeListType
    private var pageNum: Int = 3
    
    init(listType: HomeListType, navigation: HomeNavigation) {
        self.listType = listType
        self.navigation = navigation
    }
    
    func goBack() {
        navigation?.popController()
    }
    
    func showMovieDetail(mediaType: MediaType, id: Int) {
        navigation?.showDetails(mediaType: mediaType, id: id)
    }
    
    func getAllItems() -> Int {
        return resultList.count
    }
    
    func getMediatype() -> MediaType {
        switch listType {
        case .movie(_):
            return .movie
        case .tvShow(_):
            return .tvShow
        }
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
    
    func getInitialList() {
        switch listType {
        case .movie(let movie):
            switch movie {
            case .nowPlaying:
                getInitialAllNowPlayingMovies()
            case .popular:
                getInitialAllPopularMovies()
            case .topRated:
                getInitialAllTopRatedMovies()
            case .upcoming:
                getInitialAllUpcomingMovies()
            }
        case .tvShow(let tvShow):
            switch tvShow{
            case .onTheAir:
                getInitialOnTheAirTvShows()
            case .popular:
                getInitialPopularTvShows()
            case .topRated:
                getInitialTopRatedTvShows()
            case .airingToday:
                getInitialAiringTodayTvShows()
            }
        }
    }
    
    fileprivate func getList() {
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
    
    func loadMorePage() {
        pageNum += 1
        if pageNum >= 500 { return }
        getList()
    }
    
    // MARK: Tv Show Lists Function
    
    fileprivate func getInitialOnTheAirTvShows() {
        requestCallback?(.loading)
        for i in 1...3 {
            self.tvShowListsUse.getOnTheAirTvShows(page: String(i)) { [weak self] dto, error in
                guard let self = self else { return }
                if let dto = dto {
                    resultList += dto.results.map{ ResultType.tvShow($0) }
                } else if let error = error {
                    requestCallback?(.error(message: error))
                }
            }
        }
        requestCallback?(.loaded)
        requestCallback?(.success)
    }
    
    fileprivate func getOnTheAirTvShows() {
        requestCallback?(.morePageLoading)
        tvShowListsUse.getOnTheAirTvShows(page: String(pageNum)) { [weak self] dto, error in
            guard let self = self else { return }
            if let dto = dto {
                resultList += dto.results.map{ ResultType.tvShow($0) }
                requestCallback?(.success)
                requestCallback?(.morePageLoaded)
            } else if let error = error {
                requestCallback?(.error(message: error))
            }
        }
    }
    
    fileprivate func getInitialPopularTvShows() {
        requestCallback?(.loading)
        for i in 1...3 {
            self.tvShowListsUse.getPopularTvShows(page: String(i)) { [weak self] dto, error in
                guard let self = self else { return }
                if let dto = dto {
                    resultList += dto.results.map{ ResultType.tvShow($0) }
                } else if let error = error {
                    requestCallback?(.error(message: error))
                }
            }
        }
        requestCallback?(.loaded)
        requestCallback?(.success)
    }
    
    fileprivate func getPopularTvShows() {
        requestCallback?(.morePageLoading)
        tvShowListsUse.getPopularTvShows(page: String(pageNum)) { [weak self] dto, error in
            guard let self = self else { return }
            if let dto = dto {
                resultList += dto.results.map{ ResultType.tvShow($0) }
                requestCallback?(.success)
                requestCallback?(.morePageLoaded)
            } else if let error = error {
                requestCallback?(.error(message: error))
            }
        }
    }
    
    fileprivate func getInitialTopRatedTvShows() {
        requestCallback?(.loading)
        for i in 1...3 {
            self.tvShowListsUse.getTopRatedTvShows(page: String(i)) { [weak self] dto, error in
                guard let self = self else { return }
                if let dto = dto {
                    resultList += dto.results.map{ ResultType.tvShow($0) }
                } else if let error = error {
                    requestCallback?(.error(message: error))
                }
            }
        }
        requestCallback?(.loaded)
        requestCallback?(.success)
    }
    
    fileprivate func getTopRatedTvShows() {
        requestCallback?(.morePageLoading)
        tvShowListsUse.getTopRatedTvShows(page: String(pageNum)) { [weak self] dto, error in
            guard let self = self else { return }
            if let dto = dto {
                resultList += dto.results.map{ ResultType.tvShow($0) }
                requestCallback?(.success)
                requestCallback?(.morePageLoaded)
            } else if let error = error {
                requestCallback?(.error(message: error))
            }
        }
    }
    
    fileprivate func getInitialAiringTodayTvShows() {
        requestCallback?(.loading)
        for i in 1...3 {
            self.tvShowListsUse.getAiringTodayTvShows(page: String(i)) { [weak self] dto, error in
                guard let self = self else { return }
                if let dto = dto {
                    resultList += dto.results.map{ ResultType.tvShow($0) }
                } else if let error = error {
                    requestCallback?(.error(message: error))
                }
            }
        }
        requestCallback?(.loaded)
        requestCallback?(.success)
    }
    
    fileprivate func getAiringTodayTvShows() {
        requestCallback?(.morePageLoading)
        tvShowListsUse.getAiringTodayTvShows(page: String(pageNum)) { [weak self] dto, error in
            guard let self = self else { return }
            if let dto = dto {
                resultList += dto.results.map{ ResultType.tvShow($0) }
                requestCallback?(.success)
                requestCallback?(.morePageLoaded)
            } else if let error = error {
                requestCallback?(.error(message: error))
            }
        }
    }
    
    // MARK: Movie Lists Functions
    
    fileprivate func getInitialAllNowPlayingMovies() {
        requestCallback?(.loading)
        for i in 1...3 {
            self.movieListsUse.getNowPlayingMovies(page: String(i)) { [weak self] dto, error in
                guard let self = self else { return }
                if let dto = dto {
                    resultList += dto.results.map{ ResultType.movie($0) }
                } else if let error = error {
                    requestCallback?(.error(message: error))
                }
            }
        }
        requestCallback?(.loaded)
        requestCallback?(.success)
    }
    
    fileprivate func getAllNowPlayingMovies() {
        requestCallback?(.morePageLoading)
        movieListsUse.getNowPlayingMovies(page: String(pageNum)) { [weak self] dto, error in
            guard let self = self else { return }
            if let dto = dto {
                resultList += dto.results.map{ ResultType.movie($0) }
                requestCallback?(.success)
                requestCallback?(.morePageLoaded)
            } else if let error = error {
                requestCallback?(.error(message: error))
            }
        }
    }
    
    fileprivate func getInitialAllPopularMovies() {
        requestCallback?(.loading)
        for i in 1...3 {
            self.movieListsUse.getPopularMovies(page: String(i)) { [weak self] dto, error in
                guard let self = self else { return }
                if let dto = dto {
                    resultList += dto.results.map{ ResultType.movie($0) }
                } else if let error = error {
                    requestCallback?(.error(message: error))
                }
            }
        }
        requestCallback?(.loaded)
        requestCallback?(.success)
    }
    
    fileprivate func getAllPopularMovies() {
        requestCallback?(.morePageLoading)
        movieListsUse.getPopularMovies(page: String(pageNum)) { [weak self] dto, error in
            guard let self = self else { return }
            if let dto = dto {
                resultList += dto.results.map{ ResultType.movie($0) }
                requestCallback?(.success)
                requestCallback?(.morePageLoaded)
            } else if let error = error {
                requestCallback?(.error(message: error))
            }
        }
    }

    fileprivate func getInitialAllTopRatedMovies() {
        requestCallback?(.loading)
        for i in 1...3 {
            self.movieListsUse.getTopRatedMovies(page: String(i)) { [weak self] dto, error in
                guard let self = self else { return }
                if let dto = dto {
                    resultList += dto.results.map{ ResultType.movie($0) }
                } else if let error = error {
                    requestCallback?(.error(message: error))
                }
            }
        }
        requestCallback?(.loaded)
        requestCallback?(.success)
    }
    
    fileprivate func getAllTopRatedMovies() {
        requestCallback?(.morePageLoading)
        movieListsUse.getTopRatedMovies(page: String(pageNum)) { [weak self] dto, error in
            guard let self = self else { return }
            if let dto = dto {
                resultList += dto.results.map{ ResultType.movie($0) }
                requestCallback?(.success)
                requestCallback?(.morePageLoaded)
            } else if let error = error {
                requestCallback?(.error(message: error))
            }
        }
    }
    
    fileprivate func getInitialAllUpcomingMovies() {
        requestCallback?(.loading)
        for i in 1...3 {
            self.movieListsUse.getUpcomingMovies(page: String(i)) { [weak self] dto, error in
                guard let self = self else { return }
                if let dto = dto {
                    resultList += dto.results.map{ ResultType.movie($0) }
                } else if let error = error {
                    requestCallback?(.error(message: error))
                }
            }
        }
        requestCallback?(.loaded)
        requestCallback?(.success)
    }
    
    fileprivate func getAllUpcomingMovies() {
        requestCallback?(.morePageLoading)
        movieListsUse.getUpcomingMovies(page: String(pageNum)) { [weak self] dto, error in
            guard let self = self else { return }
            if let dto = dto {
                resultList += dto.results.map{ ResultType.movie($0) }
                requestCallback?(.success)
                requestCallback?(.morePageLoaded)
            } else if let error = error {
                requestCallback?(.error(message: error))
            }
        }
    }
}
