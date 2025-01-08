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
        case error(message: String)
    }
    
    var requestCallback : ((ViewState) -> Void?)?
    
    private var movieListsUse: MovieListsUseCase = MovieListsAPIService()
    private var tvShowListsUse: TvShowListsUseCase = TvShowListsAPIService()
    
    private(set) var movieSearchDto: [MovieResultDTO] = []
    private(set) var tvShowSearchDto: [TvShowResultDTO] = []
    
    func movieSearch(query: String) {
        requestCallback?(.loading)
        movieListsUse.getMovieSearchResults(query: query) { [weak self] dto, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.requestCallback?(.loaded)
                if let dto = dto {
                    self.movieSearchDto = dto.results
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
    
    func tvShowSearch(query: String) {
        requestCallback?(.loading)
        tvShowListsUse.getTvShowSearchResults(query: query) { [weak self] dto, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.requestCallback?(.loaded)
                if let dto = dto {
                    self.tvShowSearchDto = dto.results
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
