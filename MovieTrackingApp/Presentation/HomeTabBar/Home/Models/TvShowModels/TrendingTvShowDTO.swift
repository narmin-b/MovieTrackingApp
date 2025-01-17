//
//  TrendingTvShowDTO.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 28.12.24.
//

import Foundation

// MARK: - TrendingTvShowDTO
struct TrendingTvShowDTO: Codable {
    let page: Int
    let results: [TrendingTvShowResult]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - TrendingTvShowResult
struct TrendingTvShowResult: Codable {
    let backdropPath: String
    let id: Int
    let name, originalName, overview, posterPath: String
    let mediaType: String
    let adult: Bool
    let originalLanguage: String
    let genreIDS: [Int]
    let popularity: Double
    let firstAirDate: String
    let voteAverage: Double
    let voteCount: Int
    let originCountry: [String]

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case id, name
        case originalName = "original_name"
        case overview
        case posterPath = "poster_path"
        case mediaType = "media_type"
        case adult
        case originalLanguage = "original_language"
        case genreIDS = "genre_ids"
        case popularity
        case firstAirDate = "first_air_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case originCountry = "origin_country"
    }
}

extension TrendingTvShowResult {
    func mapToDomain() -> TitleImageCellProtocol {
        .init(titleString: name,
              imageString: posterPath,
              overviewString: overview,
              voteString: String(voteAverage),
              idInt: id
        )
    }
}
