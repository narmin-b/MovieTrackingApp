//
//  RatedMoviesDTO.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 17.01.25.
//

import Foundation

struct RatedMovieListsDTO: Codable {
    let page: Int
    let results: [RatedMovieResultDTO]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct RatedMovieResultDTO: Codable {
    let adult: Bool
    let backdropPath: String
    let genreIDS: [Int]
    let id: Int
    let originalLanguage, originalTitle, overview: String
    let popularity: Double
    let posterPath, releaseDate, title: String
    let video: Bool
    let voteAverage: Double
    let voteCount, rating: Int

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
        case rating
    }
}

extension RatedMovieResultDTO {
    func mapToDomain() -> TitleImageCellWithRatingProtocol {
        .init(titleString: title,
              imageString: posterPath,
              overviewString: overview,
              voteString: String(voteAverage),
              idInt: id,
              ratingString: String(rating)
        )
    }
}
