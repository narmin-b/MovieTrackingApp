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
        case ratingSuccess
        case error(message: String)
    }
    
    var requestCallback : ((ViewState) -> Void?)?
    private weak var navigation: HomeNavigation?

    private var movieDetailsUse: MovieDetailUseCase = MovieDetailAPIService()
    private var tvShowDetailsUse: TvShowDetailUseCase = TvShowDetailAPIService()
    private var guestSessionUse: GuestSessionUseCase = GuestSessionAPIService()
    private(set) var postSuccessDTO: POSTSuccessProtocol?
    
    private var id: Int
    private var mediaType: MediaType
    private var sessionID: String
    private(set) var movieDetails: MovieDetailProtocol?
    private(set) var tvShowDetails: TvShowDetailProtocol?
    private(set) var titleVideos: TitleVideoProtocol?
    private(set) var ratedMovieDto: [TitleImageCellWithRatingProtocol] = []
    private(set) var ratedTvShowDto: [TitleImageCellWithRatingProtocol] = []
    
    private let baseImageUrl: String = "https://image.tmdb.org/t/p/w500"
    private let baseVideoUrl: String = "https://www.youtube.com/embed/"

    init(mediaType: MediaType, id: Int, navigation: HomeNavigation) {
        self.navigation = navigation
        self.id = id
        self.mediaType = mediaType
        self.sessionID = UserDefaultsHelper.getString(key: UserDefaultsKey.guestSessionID.rawValue) ?? ""
    }
    
    func popControllerBack() {
        navigation?.popController()
    }
    
    func getMediaType() -> MediaType {
        return mediaType
    }
    
    //MARK: User Rating Functions
    
    fileprivate func getRatedMovies(completion: @escaping () -> Void) {
        guestSessionUse.getRatedMovies(id: sessionID) { [weak self] dto, error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let dto = dto {
                    self.ratedMovieDto = dto.results.map({ $0.mapToDomain() })
                    completion()
                } else if let error = error {
                    print(#function, error)
//                    self.requestCallback?(.error(message: error))
                }
            }
        }
    }
    
    fileprivate func getRatedTvShows(completion: @escaping () -> Void) {
        guestSessionUse.getRatedTvShows(id: sessionID) { [weak self] dto, error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let dto = dto {
                    self.ratedTvShowDto = dto.results.map({ $0.mapToDomain() })
                    completion()
                } else if let error = error {
                    print(#function, error)
//                    self.requestCallback?(.error(message: error))
                }
            }
        }
    }
    
    func loadDataAndCheckIfRated(completion: @escaping (Bool) -> Void) {
        switch mediaType {
        case .movie:
            getRatedMovies {
                completion(self.ratedMovieDto.contains(where: { $0.idInt == self.id }))
            }
        case .tvShow:
            getRatedTvShows {
                completion(self.ratedTvShowDto.contains(where: { $0.idInt == self.id }))
            }
        }
    }
    
    func getRating() -> Int {
        switch mediaType {
        case .movie:
            return (Int(ratedMovieDto.first(where: { $0.idInt == id })?.ratingString ?? "0") ?? 0)/2
        case .tvShow:
            return (Int(ratedTvShowDto.first(where: { $0.idInt == id })?.ratingString ?? "0") ?? 0)/2
        }
    }
        
    func setRating(rating: Int) {
        print(sessionID)
        switch mediaType {
        case .movie:
            guestSessionUse.rateMovie(titleID: String(id), sessionID: sessionID, rating: rating) { [weak self] dto, error in
                guard let self = self else { return }
                if let dto = dto {
                    postSuccessDTO = dto.mapToDomain()
                    if postSuccessDTO?.success == true {
                        requestCallback?(.ratingSuccess)
                    } else {
                        requestCallback?(.error(message: "Rating couldn't be saved"))
                    }
                } else if let error = error {
                    requestCallback?(.error(message: error))
                }
            }
        case .tvShow:
            guestSessionUse.rateTvShow(titleID: String(id), sessionID: sessionID, rating: rating) { [weak self] dto, error in
                guard let self = self else { return }
                if let dto = dto {
                    postSuccessDTO = dto.mapToDomain()
                    if postSuccessDTO?.success == true {
                        requestCallback?(.ratingSuccess)
                    } else {
                        requestCallback?(.error(message: "Rating couldn't be saved"))
                    }
                } else if let error = error {
                    requestCallback?(.error(message: error))
                }
            }
        }
    }
    
    //MARK: Detail Functions
    
    func getDetails() {
        switch mediaType {
        case .movie:
            requestCallback?(.loading)
            movieDetailsUse.getMovieDetail(id: String(id)) { [weak self] dto, error in
                guard let self = self else { return }
                if let dto = dto {
                    movieDetails = dto.mapToDomain()
                    requestCallback?(.success)
                    requestCallback?(.loaded)
                } else if let error = error {
                    requestCallback?(.error(message: error))
                }
            }
            movieDetailsUse.getMovieVideos(id: String(id)) { [weak self] dto, error in
                guard let self = self else { return }
                if let dto = dto {
                    titleVideos = dto.mapToDomain()
                    requestCallback?(.success)
                } else if let error = error {
                    requestCallback?(.error(message: error))
                }
            }
        case .tvShow:
            requestCallback?(.loading)
            tvShowDetailsUse.getTvShowDetail(id: String(id)) { [weak self] dto, error in
                guard let self = self else { return }
                if let dto = dto {
                    tvShowDetails = dto.mapToDomain()
                    requestCallback?(.success)
                    requestCallback?(.loaded)
                } else if let error = error {
                    requestCallback?(.error(message: error))
                }
            }
            tvShowDetailsUse.getTvShowVideos(id: String(id)) { [weak self] dto, error in
                guard let self = self else { return }
                if let dto = dto {
                    titleVideos = dto.mapToDomain()
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
    
    func getMovieTitle() -> String {
        switch mediaType {
        case .movie:
            return movieDetails?.titleStr ?? ""
        case .tvShow:
            return tvShowDetails?.nameStr ?? ""
        }
    }
    
    
    func getMovieBackdropImage() -> String {
        switch mediaType {
        case .movie:
            return baseImageUrl + (movieDetails?.backdropPathStr ?? "")
        case .tvShow:
            return baseImageUrl + (tvShowDetails?.backdropPathStr ?? "")
        }
    }
    
    func getMoviePosterImage() -> String {
        switch mediaType {
        case .movie:
            return baseImageUrl + (movieDetails?.posterPathStr ?? "")
        case .tvShow:
            return baseImageUrl + (tvShowDetails?.posterPathStr ?? "")
        }
    }
    
    func getMovieRuntime() -> String {
        switch mediaType {
        case .movie:
            return String(movieDetails?.runtimeInt ?? 0) + " min"
        case .tvShow:
            return String(tvShowDetails?.numberOfSeasonsInt ?? 0) + " seasons"
        }
    }
    
    func getMovieLanguage() -> String {
        switch mediaType {
        case .movie:
            return movieDetails?.spokenLanguagesLng.map{$0.englishName ?? ""}.first ?? ""
        case .tvShow:
            return (tvShowDetails?.spokenLanguagesArr.map{$0.englishName ?? ""} ?? []).first ?? ""
        }
    }
    
    func getMovieReleaseDate() -> String {
        switch mediaType {
        case .movie:
            return movieDetails?.releaseDateStr ?? ""
        case .tvShow:
            return tvShowDetails?.firstAirDateStr ?? ""
        }
    }
    
    func getMovieOverview() -> String {
        switch mediaType {
        case .movie:
            return movieDetails?.overviewStr ?? ""
        case .tvShow:
            return tvShowDetails?.overviewStr ?? ""
        }
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
