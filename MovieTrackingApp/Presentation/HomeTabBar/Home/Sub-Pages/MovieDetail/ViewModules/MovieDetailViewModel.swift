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
    private var tvShowDetailsUse: TvShowDetailUseCase = TvShowDetailAPIService()

//    private weak var navigation: HomeNavigation?
    
    private var id: Int
    private var mediaType: MediaType
    private(set) var movieDetails: MovieDetailProtocol?
    private(set) var tvShowDetails: TvShowDetailProtocol?
    private(set) var titleVideos: TitleVideoProtocol?

    
    private let baseImageUrl: String = "https://image.tmdb.org/t/p/w500"
    private let baseVideoUrl: String = "https://www.youtube.com/embed/"
    
    init(mediaType: MediaType, id: Int) {
        self.id = id
        self.mediaType = mediaType
//        self.navigation = navigation
    }
    
    func getMediaType() -> MediaType {
        return mediaType
    }
        
    func getDetails() {
        switch mediaType {
        case .movie:
            requestCallback?(.loading)
            movieDetailsUse.getMovieDetail(id: String(id)) { [weak self] dto, error in
                guard let self = self else { return }
                if let dto = dto {
                    movieDetails = dto
                    requestCallback?(.success)
                    requestCallback?(.loaded)
                } else if let error = error {
                    requestCallback?(.error(message: error))
                }
            }
            movieDetailsUse.getMovieVideos(id: String(id)) { [weak self] dto, error in
                guard let self = self else { return }
                if let dto = dto {
                    titleVideos = dto
                    requestCallback?(.success)
                    requestCallback?(.loaded)
                } else if let error = error {
                    requestCallback?(.error(message: error))
                }
            }
        case .tvShow:
            requestCallback?(.loading)
            tvShowDetailsUse.getTvShowDetail(id: String(id)) { [weak self] dto, error in
                guard let self = self else { return }
                if let dto = dto {
                    tvShowDetails = dto
                    requestCallback?(.success)
                } else if let error = error {
                    requestCallback?(.error(message: error))
                }
            }
            tvShowDetailsUse.getTvShowVideos(id: String(id)) { [weak self] dto, error in
                guard let self = self else { return }
                if let dto = dto {
                    titleVideos = dto
                    requestCallback?(.success)
                } else if let error = error {
                    requestCallback?(.error(message: error))
                }
            }
        }
        
    }
    
    func getTitleTrailer() -> String {
        return baseVideoUrl + (titleVideos?.videoId ?? "")
    }
    
    //MARK: Movie Detail Functions
    
    func getMovieTitle() -> String {
        return movieDetails?.titleStr ?? ""
    }
    
    func getMovieBackdropImage() -> String {
        return baseImageUrl + (movieDetails?.backdropPathStr ?? "")
    }
    
    func getMoviePosterImage() -> String {
        return baseImageUrl + (movieDetails?.posterPathStr ?? "")
    }
    
    func getMovieRuntime() -> Int {
        return movieDetails?.runtimeInt ?? 0
    }
    
    func getMovieLanguage() -> String {
        return movieDetails?.spokenLanguagesLng.map{$0.englishName ?? ""}.first ?? ""
    }
    
    func getMovieReleaseDate() -> String {
        return movieDetails?.releaseDateStr ?? ""
    }
    
    func getMovieOverview() -> String {
        return movieDetails?.overviewStr ?? ""
    }
    
    func getTitleForMovieCell(field: MovieInfoList) -> String {
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
        case .vote:
            let voteAverage = movieDetails?.voteAverageDbl ?? 0
            let voteCount = movieDetails?.voteCountInt
            return "\(voteAverage)  (\(voteCount ?? 0))"
        }
    }
    
    //MARK: Tv Show Detail Functions
    
    func getTvShowTitle() -> String {
        return tvShowDetails?.nameStr ?? ""
    }
    
    func getTvShowBackdropImage() -> String {
        return baseImageUrl + (tvShowDetails?.backdropPathStr ?? "")
    }
    
    func getTvShowPosterImage() -> String {
        return baseImageUrl + (tvShowDetails?.posterPathStr ?? "")
    }
    
    func getTvShowSeasons() -> Int {
        return tvShowDetails?.numberOfSeasonsInt ?? 0
    }
  
    func getTvShowLanguage() -> String {
        return (tvShowDetails?.spokenLanguagesArr.map{$0.englishName ?? ""} ?? []).first ?? ""
    }
    
    func getTvShowReleaseDate() -> String {
        return tvShowDetails?.firstAirDateStr ?? ""
    }
    
    func getTvShowOverview() -> String {
        return tvShowDetails?.overviewStr ?? ""
    }
    
    func getTitleForTvShowCell(field: TvShowInfoList) -> String {
        switch field {
        case .genre:
            var genreStr = tvShowDetails?.genresArr.first ?? ""
            let genreArray = tvShowDetails?.genresArr.dropFirst()
            genreArray?.forEach { genreStr += ", " + $0 }
            return genreStr
        case .originCountry:
            var originCountryStr = tvShowDetails?.originCountryStrArr.first ?? "" //.originCountryStr.first ?? ""
            let originCountryArray = tvShowDetails?.originCountryStrArr.dropFirst()
            originCountryArray?.forEach { originCountryStr += ", " + $0 }
            return originCountryStr
        case .vote:
            let voteAverage = tvShowDetails?.voteAverageDbl ?? 0
            let voteCount = tvShowDetails?.voteCountInt
            return "\(voteAverage)  (\(voteCount ?? 0))"
        case .numOfEpisodes:
            return String(tvShowDetails?.numberOfEpisodesInt ?? 0)
        }
    }
}
