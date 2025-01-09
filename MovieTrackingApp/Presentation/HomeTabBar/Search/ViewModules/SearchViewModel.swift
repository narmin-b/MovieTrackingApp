//
//  SearchViewModel.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 21.12.24.
//

import Foundation

final class SearchViewModel {
    enum ViewState {
        case loading
        case loaded
        case success
        case morePageLoading
        case morePageLoaded
        case error(message: String)
    }
    
    var requestCallback : ((ViewState) -> Void?)?
    private var pages: Int = 0
    private var currentPage: Int = 1
    
    
    private var movieListsUse: MovieListsUseCase = MovieListsAPIService()
    private var tvShowListsUse: TvShowListsUseCase = TvShowListsAPIService()
    
    private(set) var movieSearchDto: [MovieResultDTO] = []
    private(set) var tvShowSearchDto: [TvShowResultDTO] = []
    
    func loadMorePage(mediaType: MediaType, query: String) {
        if currentPage >= pages { return }

        currentPage += 1
        if mediaType == .movie {
            movieLoadMore(query: query)
        } else {
            tvShowLoadMore(query: query)
        }
    }
    
    func getList(mediaType: MediaType, query: String) {
        if mediaType == .movie {
            movieSearch(query: query)
        } else {
            tvShowSearch(query: query)
        }
    }
    
    fileprivate func movieSearch(query: String) {
        requestCallback?(.loading)
        movieListsUse.getMovieSearchResults(query: query, page: "1") { [weak self] dto, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.requestCallback?(.loaded)
                if let dto = dto {
                    self.movieSearchDto = dto.results
                    self.pages = dto.totalPages
                    self.currentPage = 1
                    self.requestCallback?(.success)
                } else if let error = error {
                    self.requestCallback?(.error(message: error))
                }
            }
        }
    }
    
    fileprivate func movieLoadMore(query: String) {
        requestCallback?(.morePageLoading)
        movieListsUse.getMovieSearchResults(query: query, page: String(currentPage)) { [weak self] dto, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if let dto = dto {
                    self.movieSearchDto += dto.results
                    self.requestCallback?(.morePageLoaded)
                    self.requestCallback?(.success)
                } else if let error = error {
                    self.requestCallback?(.error(message: error))
                }
            }
        }
    }
    
    func getMovieSearchItemsProtocol(index: Int) -> TitleImageCellProtocol? {
        return movieSearchDto[index]
    }
    
    func getMovieSearchItems() -> Int {
        movieSearchDto.count
    }
    
    fileprivate func tvShowSearch(query: String) {
        requestCallback?(.loading)
        tvShowListsUse.getTvShowSearchResults(query: query, page: "1") { [weak self] dto, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.requestCallback?(.loaded)
                if let dto = dto {
                    self.tvShowSearchDto = dto.results
                    self.pages = dto.totalPages
                    self.currentPage = 1
                    self.requestCallback?(.success)
                } else if let error = error {
                    self.requestCallback?(.error(message: error))
                }
            }
        }
    }
    
    fileprivate func tvShowLoadMore(query: String) {
        requestCallback?(.morePageLoading)
        tvShowListsUse.getTvShowSearchResults(query: query, page: String(currentPage)) { [weak self] dto, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if let dto = dto {
                    self.tvShowSearchDto += dto.results
                    self.requestCallback?(.morePageLoaded)
                    self.requestCallback?(.success)
                } else if let error = error {
                    self.requestCallback?(.error(message: error))
                }
            }
        }
    }
    
    func getTvShowSearchItems() -> Int {
        tvShowSearchDto.count
    }
    
    func getTvShowSearchItemsProtocol(index: Int) -> TitleImageCellProtocol? {
        return tvShowSearchDto[index]
    }
}
