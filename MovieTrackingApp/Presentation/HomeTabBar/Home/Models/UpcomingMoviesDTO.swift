//
//  UpcomingMoviesDTO.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 21.12.24.
//

import Foundation

// MARK: - UpcomingMoviesDTO
struct UpcomingMoviesDTO: Codable {
    let dates: ReleaseDates
    let page: Int
    let results: [UpcomingResult]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Dates
struct ReleaseDates: Codable {
    let maximum, minimum: String
}

// MARK: - Result
struct UpcomingResult: Codable {
    let adult: Bool
    let backdropPath: String
    let genreIDS: [Int]
    let id: Int
    let originalLanguage, originalTitle, overview: String
    let popularity: Double
    let posterPath, releaseDate, title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

typealias UpcomingMoviesList = [UpcomingResult]

extension UpcomingResult: TitleImageCellProtocol {
    var titleString: String {
        originalTitle
    }
    
    var imageString: String {
        posterPath
    }
}
