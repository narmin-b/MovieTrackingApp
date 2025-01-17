//
//  RatedTvShowsDTO.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 17.01.25.
//

import Foundation

struct RatedTvShowsDTO: Codable {
    let page: Int
    let results: [RatedTvShowResultDTO]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct RatedTvShowResultDTO: Codable {
    let adult: Bool
    let backdropPath: String
    let genreIDS: [Int]
    let id: Int
    let originCountry: [String]
    let originalLanguage, originalName, overview: String
    let popularity: Double
    let posterPath, firstAirDate, name: String
    let voteAverage: Double
    let voteCount, rating: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case overview, popularity
        case posterPath = "poster_path"
        case firstAirDate = "first_air_date"
        case name
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case rating
    }
}

extension RatedTvShowResultDTO {
    func mapToDomain() -> TitleImageCellWithRatingProtocol {
        .init(titleString: name,
              imageString: posterPath,
              overviewString: overview,
              voteString: String(voteAverage),
              idInt: id,
              ratingString: String(rating))
    }
}
