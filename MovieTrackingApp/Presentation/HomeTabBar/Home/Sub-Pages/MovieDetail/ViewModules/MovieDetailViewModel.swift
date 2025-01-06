//
//  MovieDetailViewModel.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 19.12.24.
//

import Foundation
import UIKit

final class MovieDetailViewModel {
    enum ViewState {
        case loading
        case loaded
        case success
        case error(message: String)
    }
    
    var requestCallback : ((ViewState) -> Void?)?
    private var movieDetailsUse: MovieDetailUseCase = MovieDetailAPIService()
    private weak var navigation: HomeNavigation?
    
    private var id: Int
    private var mediaType: MediaType
    private(set) var movieDetails: MovieDetailProtocol?
    
    private let baseImageUrl: String = "https://image.tmdb.org/t/p/w500"
    
    init(mediaType: MediaType, id: Int, navigation: HomeNavigation) {
        self.id = id
        self.mediaType = mediaType
        self.navigation = navigation
    }
    
    func getMovieDetails() {
        requestCallback?(.loading)
        movieDetailsUse.getMovieDetail(id: String(id)) { [weak self] dto, error in
            guard let self = self else { return }
            requestCallback?(.loaded)
            if let dto = dto {
                movieDetails = dto
                requestCallback?(.success)
            } else if let error = error {
                requestCallback?(.error(message: error))
            }
        }
    }
    
    func getBackdropImage() -> String {
        return baseImageUrl + (movieDetails?.backdropPathStr ?? "")
    }
    
    func getPosterImage() -> String {
        return baseImageUrl + (movieDetails?.posterPathStr ?? "")
    }
    
    func getTitleForCell(field: InfoList) -> String {
        switch field {
        case .genre:
            var genreStr = movieDetails?.genresArr.first ?? ""
            let genreArray = movieDetails?.genresArr.dropFirst()
            genreArray?.forEach { genreStr += ", " + $0 }
            return genreStr
        case .originCountry:
            var originCountryStr = movieDetails?.originCountryStr.first ?? ""
            let originCountryArray = movieDetails?.originCountryStr.dropFirst()
            originCountryArray?.forEach { originCountryStr += ", " + $0 }
            return originCountryStr
        }
    }
}
