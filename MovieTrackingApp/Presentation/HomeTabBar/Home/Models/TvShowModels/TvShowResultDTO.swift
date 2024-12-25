//
//  TvShowResultDTO.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 25.12.24.
//

import Foundation

struct TvShowResultDTO: Codable {
    let adult: Bool
    let backdropPath: String?
    let genreIDS: [Int]
    let id: Int
    let originCountry: [String]
    let originalLanguage: String
    let originalName, overview: String
    let popularity: Double
    let posterPath, firstAirDate, name: String
    let voteAverage: Double
    let voteCount: Int

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
    }
}

extension TvShowResultDTO: TitleImageCellProtocol {
    var titleString: String {
        name
    }
    
    var imageString: String {
        posterPath
    }
}
