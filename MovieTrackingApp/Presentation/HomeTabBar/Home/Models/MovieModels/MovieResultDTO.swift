//
//  MovieResultDTO.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 22.12.24.
//

import Foundation

struct MovieResultDTO: Codable {
    let adult: Bool
    let backdropPath: String?
    let genreIDS: [Int]
    let id: Int
    let originalLanguage: String
    let originalTitle, overview: String
    let popularity: Double
    let posterPath: String?
    let releaseDate, title: String
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

extension MovieResultDTO {
    func mapToDomain() -> TitleImageCellProtocol {
        .init(titleString: title,
              imageString: posterPath ?? "",
              overviewString: overview,
              ratingString: String(voteAverage),
              idInt: id)
    }
}
