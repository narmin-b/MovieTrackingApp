//
//  MovieResultDTO.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 22.12.24.
//

import Foundation

struct MovieResultDTO: Codable {
    let adult: Bool
    let backdropPath: String
    let genreIDS: [Int]
    let id: Int
    let originalLanguage: String
    let originalTitle, overview: String
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

extension MovieResultDTO: TitleImageCellProtocol {
    var titleString: String {
        originalTitle
    }
    
    var imageString: String {
        posterPath
    }
}

extension MovieResultDTO: MovieDetailProtocol {
    var adultBool: Bool {
        adult
    }
    
    var backdropPathStr: String {
        backdropPath
    }
    
    var genreIDSInt: [Int] {
        genreIDS
    }
    
    var idInt: Int {
        id
    }
    
    var originalLanguageStr: String {
        originalLanguage
    }
    
    var originalTitleStr: String {
        originalTitle
    }
    
    var overviewStr: String {
        overview
    }
    
    var popularityDbl: Double {
        popularity
    }
    
    var posterPathStr: String {
        posterPath
    }
    
    var releaseDateStr: String {
        releaseDate
    }
    
    var titleStr: String {
        title
    }
    
    var videoBool: Bool {
        video
    }
    
    var voteAverageDbl: Double {
        voteAverage
    }
    
    var voteCountInt: Int {
        voteCount
    }
}
