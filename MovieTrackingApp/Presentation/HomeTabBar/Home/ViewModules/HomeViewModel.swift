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
    private let movieListsUse: MovieListsUseCase
    private let tvShowListsUse: TvShowListsUseCase

    private weak var navigation: HomeNavigation?
    
    private var seeAllList: [MovieResultDTO] = []
    
    init(navigation: HomeNavigation, movieListsUse: MovieListsUseCase, tvShowListsUse: TvShowListsUseCase) {
        self.navigation = navigation
        self.movieListsUse = movieListsUse
        self.tvShowListsUse = tvShowListsUse
    }
    
    func showTitleDetail(mediaType: MediaType, id: Int) {
        navigation?.showDetails(mediaType: mediaType, id: id)
    }
    
    func showAllItems(listType: HomeListType) {
        navigation?.showAllItems(listType: listType)
    }
        

    private(set) var nowPlayingDto: [TitleImageCellProtocol] = []
    private(set) var popularMoviesDto: [TitleImageCellProtocol] = []
    private(set) var topRatedMoviesDto: [TitleImageCellProtocol] = []
    private(set) var upcomingMoviesDto: [TitleImageCellProtocol] = []
    private(set) var trendingMovieDto: [TitleImageCellProtocol] = []
    
    private(set) var onTheAirTvShowsDto: [TitleImageCellProtocol] = []
    private(set) var popularTvShowsDto: [TitleImageCellProtocol] = []
    private(set) var airingTodayTvShowsDto: [TitleImageCellProtocol] = []
    private(set) var topRatedTvShowsDto: [TitleImageCellProtocol] = []
    private(set) var trendingTvShowDto: [TitleImageCellProtocol] = []
    
    // MARK: Tv Show Lists Functions
    
    func getTrendingTvShows(time: Time) {
        requestCallback?(.loading)
        tvShowListsUse.getTrendingTvShows(time: time) { [weak self] dto, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.requestCallback?(.loaded)
                if let dto = dto {
                    self.trendingTvShowDto = dto.results.map({ $0.mapToDomain() })
                    self.requestCallback?(.success)
                } else if let error = error {
                    self.requestCallback?(.error(message: error))
                }
            }
        }
    }
    
    func getTrendingTvShowItems() -> Int {
        return trendingTvShowDto.count
    }
    
    func getTrendingTvShowProtocol(index: Int) -> TitleImageCellProtocol {
        return  trendingTvShowDto[index]
    }
    
    func getTrendingTvShowItem(index: Int) -> Int {
        return trendingTvShowDto[index].idInt
    }
    
    func getOnTheAirTvShows() {
        requestCallback?(.loading)
        tvShowListsUse.getOnTheAirTvShows(page: "1") { [weak self] dto, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.requestCallback?(.loaded)
                if let dto = dto {
                    self.onTheAirTvShowsDto = dto.results.map({ $0.mapToDomain() })
                    self.requestCallback?(.success)
                } else if let error = error {
                    self.requestCallback?(.error(message: error))
                }
            }
        }
    }
    
    func getOnTheAirTvShowItems() -> Int {
        return onTheAirTvShowsDto.count
    }
    
    func getOnTheAirTvShowProtocol(index: Int) -> TitleImageCellProtocol? {
        return onTheAirTvShowsDto[index]
    }
    
    func getOnTheAirTvShowItem(index: Int) -> Int {
        return onTheAirTvShowsDto[index].idInt
    }
    
    func getPopularTvShows() {
        requestCallback?(.loading)
        tvShowListsUse.getPopularTvShows(page: "1") { [weak self] dto, error in
            guard let self = self else { return }
            self.requestCallback?(.loaded)
            DispatchQueue.main.async {
                if let dto = dto {
                    self.popularTvShowsDto = dto.results.map({ $0.mapToDomain() })
                    self.requestCallback?(.success)
                } else if let error = error {
                    self.requestCallback?(.error(message: error))
                }
            }
        }
    }
      
    func getPopularTvShowItems() -> Int {
        return popularTvShowsDto.count
    }
    
    func getPopularTvShowProtocol(index: Int) -> TitleImageCellProtocol? {
        return popularTvShowsDto[index]
    }
    
    func getPopularTvShowItem(index: Int) -> Int {
        return popularTvShowsDto[index].idInt
    }
    
    func getAiringTodayTvShows() {
        requestCallback?(.loading)
        tvShowListsUse.getAiringTodayTvShows(page: "1") { [weak self] dto, error in
            guard let self = self else { return }
            self.requestCallback?(.loaded)
            DispatchQueue.main.async {
                if let dto = dto {
                    self.airingTodayTvShowsDto = dto.results.map({ $0.mapToDomain() })
                    self.requestCallback?(.success)
                } else if let error = error {
                    self.requestCallback?(.error(message: error))
                }
            }
        }
    }
      
    func getAiringTodayTvShowItems() -> Int {
        return airingTodayTvShowsDto.count
    }
    
    func getAiringTodayTvShowProtocol(index: Int) -> TitleImageCellProtocol? {
        return airingTodayTvShowsDto[index]
    }
    
    func getAiringTodayTvShowItem(index: Int) -> Int {
        return airingTodayTvShowsDto[index].idInt
    }
    
    func getTopRatedTvShows() {
        requestCallback?(.loading)
        tvShowListsUse.getTopRatedTvShows(page: "1") { [weak self] dto, error in
            guard let self = self else { return }
            self.requestCallback?(.loaded)
            DispatchQueue.main.async {
                if let dto = dto {
                    self.topRatedTvShowsDto = dto.results.map({ $0.mapToDomain() })
                    self.requestCallback?(.success)
                } else if let error = error {
                    self.requestCallback?(.error(message: error))
                }
            }
        }
    }
      
    func getTopRatedTvShowItems() -> Int {
        return topRatedMoviesDto.count
    }
    
    func getTopRatedTvShowProtocol(index: Int) -> TitleImageCellProtocol? {
        return topRatedTvShowsDto.count == 0 ? DemoMovieTitleImageCell().mapToDomain() : topRatedTvShowsDto[index]
    }
    
    func getTopRatedTvShowItem(index: Int) -> Int {
        return topRatedTvShowsDto[index].idInt
    }
    
    // MARK: Movie Lists Functions
    
    func getTrendingMovies(time: Time) {
        requestCallback?(.loading)
        movieListsUse.getTrendingMovies(time: time) { [weak self] dto, error in
            guard let self = self else { return }
            self.requestCallback?(.loaded)
            DispatchQueue.main.async {
                if let dto = dto {
                    self.trendingMovieDto = dto.results.map({ $0.mapToDomain() })
                    self.requestCallback?(.success)
                } else if let error = error {
                    self.requestCallback?(.error(message: error))
                }
            }
        }
    }
    
    func getTrendingMovieItems() -> Int {
        return trendingMovieDto.count
    }
    
    func getTrendingMovie(index: Int) -> Int {
        return trendingMovieDto[index].idInt
    }
    
    func getTrendingMovieProtocol(index: Int) -> TitleImageCellProtocol? {
        return trendingMovieDto[index]
    }
    
    func getNowPlayingMovies() {
        requestCallback?(.loading)
        movieListsUse.getNowPlayingMovies(page: "1") { [weak self] dto, error in
            guard let self = self else { return }
            self.requestCallback?(.loaded)
            DispatchQueue.main.async {
                if let dto = dto {
                    self.nowPlayingDto = dto.results.map({ $0.mapToDomain() })
                    self.requestCallback?(.success)
                } else if let error = error {
                    self.requestCallback?(.error(message: error))
                }
            }
        }
    }
    
    func getNowPlayingMovieItems() -> Int {
        return nowPlayingDto.count
    }
    
    func getNowPlayingMovie(index: Int) -> Int {
        return nowPlayingDto[index].idInt
    }
    
    func getNowPlayingMovieProtocol(index: Int) -> TitleImageCellProtocol? {
        return nowPlayingDto[index]
    }
        
    func getPopularMovies() {
        requestCallback?(.loading)
        movieListsUse.getPopularMovies(page: "1") { [weak self] dto, error in
            guard let self = self else { return }
            self.requestCallback?(.loaded)
            DispatchQueue.main.async {
                if let dto = dto {
                    self.popularMoviesDto = dto.results.map({ $0.mapToDomain() })
                    self.requestCallback?(.success)
                } else if let error = error {
                    self.requestCallback?(.error(message: error))
                }
            }
        }
    }
    
    func getPopularMovieItems() -> Int {
        return popularMoviesDto.count
    }
    
    func getPopularMovieProtocol(index: Int) -> TitleImageCellProtocol? {
        return popularMoviesDto[index]
    }
    
    func getPopularMovie(index: Int) -> Int {
        return popularMoviesDto[index].idInt
    }
    
    func getTopRatedMovies() {
        requestCallback?(.loading)
        movieListsUse.getTopRatedMovies(page: "1") { [weak self] dto, error in
            guard let self = self else { return }
            self.requestCallback?(.loaded)
            DispatchQueue.main.async {
                if let dto = dto {
                    self.topRatedMoviesDto = dto.results.map({ $0.mapToDomain() })
                    self.requestCallback?(.success)
                } else if let error = error {
                    self.requestCallback?(.error(message: error))
                }
            }
        }
    }
    
    func getTopRatedMovieItems() -> Int {
        return topRatedMoviesDto.count
    }
    
    func getTopRatedMovie(index: Int) -> Int {
        return topRatedMoviesDto[index].idInt
    }
    
    func getTopRatedMovieProtocol(index: Int) -> TitleImageCellProtocol? {
        return topRatedMoviesDto[index]
    }
    
    func getUpcomingMovies() {
        requestCallback?(.loading)
        movieListsUse.getUpcomingMovies(page: "1") { [weak self] dto, error in
            guard let self = self else { return }
            self.requestCallback?(.loaded)
            DispatchQueue.main.async {
                if let dto = dto {
                    self.upcomingMoviesDto = dto.results.map({ $0.mapToDomain() })
                    self.requestCallback?(.success)
                } else if let error = error {
                    self.requestCallback?(.error(message: error))
                }
            }
        }
    }
    
    func getUpcomingMovieItems() -> Int {
        return upcomingMoviesDto.count
    }
    
    func getUpcomingMoviesProtocol(index: Int) -> TitleImageCellProtocol? {
        return upcomingMoviesDto[index]
    }
    
    func getUpcomingMovie(index: Int) -> Int {
        return upcomingMoviesDto[index].idInt
    }
}
