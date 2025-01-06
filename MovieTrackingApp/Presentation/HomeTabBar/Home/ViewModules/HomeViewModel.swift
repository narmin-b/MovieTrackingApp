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
    
    func showMovieDetail(mediaType: MediaType, id: Int) {
        navigation?.showDetails(mediaType: mediaType, id: id, nav: navigation!)
    }
    
    func showAllItems(listType: HomeListType) {
        navigation?.showAllItems(listType: listType)
    }
        
    private var movieListsUse: MovieListsUseCase = MovieListsAPIService()
    private var tvShowListsUse: TvShowListsUseCase = TvShowListsAPIService()

    private(set) var nowPlayingDto: [MovieResultDTO] = []
    private(set) var popularMoviesDto: [MovieResultDTO] = []
    private(set) var topRatedMoviesDto: [MovieResultDTO] = []
    private(set) var upcomingMoviesDto: [MovieResultDTO] = []
    private(set) var trendingMovieDto: [TrendingMovieResult] = []
    
    private(set) var onTheAirTvShowsDto: [TvShowResultDTO] = []
    private(set) var popularTvShowsDto: [TvShowResultDTO] = []
    private(set) var airingTodayTvShowsDto: [TvShowResultDTO] = []
    private(set) var topRatedTvShowsDto: [TvShowResultDTO] = []
    private(set) var trendingTvShowDto: [TrendingTvShowResult] = []
    
    // MARK: Tv Show Lists Functions
    
    func getTrendingTvShows(time: Time) {
        requestCallback?(.loading)
        tvShowListsUse.getTrendingTvShows(time: time) { [weak self] dto, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.requestCallback?(.loaded)
                if let dto = dto {
                    self.trendingTvShowDto = dto.results
                    self.requestCallback?(.success)
                } else if let error = error {
                    self.requestCallback?(.error(message: error))
                }
            }
        }
    }
    
    func getTrendingTvShowItems() -> Int {
        return trendingTvShowDto.count == 0 ? 10 : trendingTvShowDto.count
    }
    
    func getTrendingTvShowProtocol(index: Int) -> TitleImageCellProtocol? {
        return trendingTvShowDto.count == 0 ? DemoMovieTitleImageCell() : trendingTvShowDto[index]
    }
    
    func getOnTheAirTvShows() {
        requestCallback?(.loading)
        tvShowListsUse.getOnTheAirTvShows(page: "1") { [weak self] dto, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.requestCallback?(.loaded)
                if let dto = dto {
                    self.onTheAirTvShowsDto = dto.results
                    self.requestCallback?(.success)
                } else if let error = error {
                    self.requestCallback?(.error(message: error))
                }
            }
        }
    }
    
    func getOnTheAirTvShowItems() -> Int {
        return onTheAirTvShowsDto.count == 0 ? 10 : onTheAirTvShowsDto.count
    }
    
    func getOnTheAirTvShowProtocol(index: Int) -> TitleImageCellProtocol? {
        return onTheAirTvShowsDto.count == 0 ? DemoMovieTitleImageCell() : onTheAirTvShowsDto[index]
    }
    
    func getPopularTvShows() {
        requestCallback?(.loading)
        tvShowListsUse.getPopularTvShows(page: "1") { [weak self] dto, error in
            guard let self = self else { return }
            self.requestCallback?(.loaded)
            DispatchQueue.main.async {
                if let dto = dto {
                    self.popularTvShowsDto = dto.results
                    self.requestCallback?(.success)
                } else if let error = error {
                    self.requestCallback?(.error(message: error))
                }
            }
        }
    }
      
    func getPopularTvShowItems() -> Int {
        return popularTvShowsDto.count == 0 ? 10 : popularTvShowsDto.count
    }
    
    func getPopularTvShowProtocol(index: Int) -> TitleImageCellProtocol? {
        return popularTvShowsDto.count == 0 ? DemoMovieTitleImageCell() : popularTvShowsDto[index]
    }
    
    func getAiringTodayTvShows() {
        requestCallback?(.loading)
        tvShowListsUse.getAiringTodayTvShows(page: "1") { [weak self] dto, error in
            guard let self = self else { return }
            self.requestCallback?(.loaded)
            DispatchQueue.main.async {
                if let dto = dto {
                    self.airingTodayTvShowsDto = dto.results
                    self.requestCallback?(.success)
                } else if let error = error {
                    self.requestCallback?(.error(message: error))
                }
            }
        }
    }
      
    func getAiringTodayTvShowItems() -> Int {
        return airingTodayTvShowsDto.count == 0 ? 10 : airingTodayTvShowsDto.count
    }
    
    func getAiringTodayTvShowProtocol(index: Int) -> TitleImageCellProtocol? {
        return airingTodayTvShowsDto.count == 0 ? DemoMovieTitleImageCell() : airingTodayTvShowsDto[index]
    }
    
    func getTopRatedTvShows() {
        requestCallback?(.loading)
        tvShowListsUse.getTopRatedTvShows(page: "1") { [weak self] dto, error in
            guard let self = self else { return }
            self.requestCallback?(.loaded)
            DispatchQueue.main.async {
                if let dto = dto {
                    self.topRatedTvShowsDto = dto.results
                    self.requestCallback?(.success)
                } else if let error = error {
                    self.requestCallback?(.error(message: error))
                }
            }
        }
    }
      
    func getTopRatedTvShowItems() -> Int {
        return topRatedTvShowsDto.count == 0 ? 10 : topRatedMoviesDto.count
    }
    
    func getTopRatedTvShowProtocol(index: Int) -> TitleImageCellProtocol? {
        return topRatedTvShowsDto.count == 0 ? DemoMovieTitleImageCell() : topRatedTvShowsDto[index]
    }
    
    // MARK: Movie Lists Functions
    
    func getTrendingMovies(time: Time) {
        requestCallback?(.loading)
        movieListsUse.getTrendingMovies(time: time) { [weak self] dto, error in
            guard let self = self else { return }
            self.requestCallback?(.loaded)
            DispatchQueue.main.async {
                if let dto = dto {
                    self.trendingMovieDto = dto.results
                    self.requestCallback?(.success)
                } else if let error = error {
                    self.requestCallback?(.error(message: error))
                }
            }
        }
    }
    
    func getTrendingMovieItems() -> Int {
        return trendingMovieDto.count == 0 ? 10 : trendingMovieDto.count
    }
    
    func getTrendingMovie(index: Int) -> Int {
        return trendingMovieDto[index].id
    }
    
    func getTrendingMovieProtocol(index: Int) -> TitleImageCellProtocol? {
        return trendingMovieDto.count == 0 ? DemoMovieTitleImageCell() : trendingMovieDto[index]
    }
    
    func getNowPlayingMovies() {
        requestCallback?(.loading)
        movieListsUse.getNowPlayingMovies(page: "1") { [weak self] dto, error in
            guard let self = self else { return }
            self.requestCallback?(.loaded)
            DispatchQueue.main.async {
                if let dto = dto {
                    self.nowPlayingDto = dto.results
                    self.requestCallback?(.success)
                } else if let error = error {
                    self.requestCallback?(.error(message: error))
                }
            }
        }
    }
    
    func getNowPlayingMovieItems() -> Int {
        return nowPlayingDto.count == 0 ? 10 : nowPlayingDto.count
    }
    
    func getNowPlayingMovie(index: Int) -> Int {
        return nowPlayingDto[index].id
    }
    
    func getNowPlayingMovieProtocol(index: Int) -> TitleImageCellProtocol? {
        return nowPlayingDto.count == 0 ? DemoMovieTitleImageCell() : nowPlayingDto[index]
    }
        
    func getPopularMovies() {
        requestCallback?(.loading)
        movieListsUse.getPopularMovies(page: "1") { [weak self] dto, error in
            guard let self = self else { return }
            self.requestCallback?(.loaded)
            DispatchQueue.main.async {
                if let dto = dto {
                    self.popularMoviesDto = dto.results
                    self.requestCallback?(.success)
                } else if let error = error {
                    self.requestCallback?(.error(message: error))
                }
            }
        }
    }
    
    func getPopularMovieItems() -> Int {
        return popularMoviesDto.count == 0 ? 10 : popularMoviesDto.count
    }
    
    func getPopularMovieProtocol(index: Int) -> TitleImageCellProtocol? {
        return popularMoviesDto.count == 0 ? DemoMovieTitleImageCell() : popularMoviesDto[index]
    }
    
    func getPopularMovie(index: Int) -> Int {
        return popularMoviesDto[index].id
    }
    
    func getTopRatedMovies() {
        requestCallback?(.loading)
        movieListsUse.getTopRatedMovies(page: "1") { [weak self] dto, error in
            guard let self = self else { return }
            self.requestCallback?(.loaded)
            DispatchQueue.main.async {
                if let dto = dto {
                    self.topRatedMoviesDto = dto.results
                    self.requestCallback?(.success)
                } else if let error = error {
                    self.requestCallback?(.error(message: error))
                }
            }
        }
    }
    
    func getTopRatedMovieItems() -> Int {
        return topRatedMoviesDto.count == 0 ? 10 : topRatedMoviesDto.count
    }
    
    func getTopRatedMovie(index: Int) -> Int {
        return topRatedMoviesDto[index].id
    }
    
    func getTopRatedMovieProtocol(index: Int) -> TitleImageCellProtocol? {
        return topRatedMoviesDto.count == 0 ? DemoMovieTitleImageCell() : topRatedMoviesDto[index]
    }
    
    func getUpcomingMovies() {
        requestCallback?(.loading)
        movieListsUse.getUpcomingMovies(page: "1") { [weak self] dto, error in
            guard let self = self else { return }
            self.requestCallback?(.loaded)
            DispatchQueue.main.async {
                if let dto = dto {
                    self.upcomingMoviesDto = dto.results
                    self.requestCallback?(.success)
                } else if let error = error {
                    self.requestCallback?(.error(message: error))
                }
            }
        }
    }
    
    func getUpcomingMovieItems() -> Int {
        return upcomingMoviesDto.count == 0 ? 10 : upcomingMoviesDto.count
    }
    
    func getUpcomingMoviesProtocol(index: Int) -> TitleImageCellProtocol? {
        return upcomingMoviesDto.count == 0 ? DemoMovieTitleImageCell() : upcomingMoviesDto[index]
    }
    
    func getUpcomingMovie(index: Int) -> Int {
        return upcomingMoviesDto[index].id
    }
}
