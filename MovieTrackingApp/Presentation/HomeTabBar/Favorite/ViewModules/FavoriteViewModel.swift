//
//  FavoriteViewModel.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 20.12.24.
//

import Foundation

final class FavoriteViewModel {
    enum ViewState {
        case loading
        case loaded
        case success
        case error(message: String)
    }
    
    var requestCallback: ((ViewState) -> Void)?
    private weak var navigation: FavoriteNavigation?
    
    private var sessionID: String


    init(navigation: FavoriteNavigation) {
        self.navigation = navigation
        self.sessionID = UserDefaultsHelper.getString(key: UserDefaultsKey.guestSessionID.rawValue) ?? ""
    }
    
    private var guestSessionUse: GuestSessionUseCase = GuestSessionAPIService()
    
    private(set) var ratedMovieDto: [TitleImageCellWithRatingProtocol] = []
    private(set) var ratedTvShowDto: [TitleImageCellWithRatingProtocol] = []
    
    func showMovieDetail(mediaType: MediaType, id: Int) {
        navigation?.showDetails(mediaType: mediaType, id: id)
    }
    
    func getItem(index: Int, mediaType: MediaType) -> Int {
        switch mediaType {
        case .movie:
            return ratedMovieDto[index].idInt
        case .tvShow:
            return ratedTvShowDto[index].idInt
        }
    }
    
    func getRatedMovies() {
        requestCallback?(.loading)
        guestSessionUse.getRatedMovies(id: sessionID) { [weak self] dto, error in
            guard let self = self else { return }
            self.requestCallback?(.loaded)
            DispatchQueue.main.async {
                if let dto = dto {
                    self.ratedMovieDto = dto.results.map({ $0.mapToDomain() })
                    self.requestCallback?(.success)
                } else if let error = error {
                    print(#function, error)
//                    self.requestCallback?(.error(message: error))
                }
            }
        }
    }
    
    func getRatedTvShows() {
        requestCallback?(.loading)
        guestSessionUse.getRatedTvShows(id: sessionID) { [weak self] dto, error in
            guard let self = self else { return }
            self.requestCallback?(.loaded)
            DispatchQueue.main.async {
                if let dto = dto {
                    self.ratedTvShowDto = dto.results.map({ $0.mapToDomain() })
                    self.requestCallback?(.success)
                } else if let error = error {
                    print(#function, error)
//                    self.requestCallback?(.error(message: error))
                }
            }
        }
    }
    
    func getRatedMoviesItemsProtocol(index: Int) -> TitleImageCellWithRatingProtocol? {
        return ratedMovieDto[index]
    }
    
    func getRatedMoviesItems() -> Int {
        ratedMovieDto.count
    }
    
    func getRatedTvShowItems() -> Int {
        ratedTvShowDto.count
    }
    
    func getRatedTvShowItemsProtocol(index: Int) -> TitleImageCellWithRatingProtocol? {
        return ratedTvShowDto[index]
    }
}
