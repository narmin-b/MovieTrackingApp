//
//  MovieDetailDTO.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 24.12.24.
//

import Foundation

// MARK: - MovieDetailDTO
struct MovieDetailDTO: Codable {
    let adult: Bool?
    let backdropPath: String?
    let belongsToCollection: BelongsToCollection?
    let budget: Int?
    let genres: [Genre]
    let homepage: String?
    let id: Int?
    let imdbID: String?
    let originCountry: [String]?
    let originalLanguage, originalTitle, overview: String?
    let popularity: Double?
    let posterPath: String?
    let productionCompanies: [ProductionCompany]
    let productionCountries: [ProductionCountry]
    let releaseDate: String?
    let revenue, runtime: Int?
    let spokenLanguages: [SpokenLanguage]
    let status, tagline, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case belongsToCollection = "belongs_to_collection"
        case budget, genres, homepage, id
        case imdbID = "imdb_id"
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case revenue, runtime
        case spokenLanguages = "spoken_languages"
        case status, tagline, title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

// MARK: - BelongsToCollection
struct BelongsToCollection: Codable {
    let id: Int?
    let name, posterPath, backdropPath: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}

// MARK: - Genre
struct Genre: Codable {
    let id: Int?
    let name: String?
}

// MARK: - ProductionCompany
struct ProductionCompany: Codable {
    let id: Int?
    let logoPath, name, originCountry: String?

    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
}

// MARK: - ProductionCountry
struct ProductionCountry: Codable {
    let iso3166_1, name: String?

    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case name
    }
}

// MARK: - SpokenLanguage
struct SpokenLanguage: Codable {
    let englishName, iso639_1, name: String?

    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso639_1 = "iso_639_1"
        case name
    }
}

extension MovieDetailDTO: MovieDetailProtocol {
    var adultBool: Bool {
        adult ?? false
    }
    
    var backdropPathStr: String {
        backdropPath ?? ""
    }
    
    var genresArr: [String] {
        return genres.map { $0.name ?? "" }
    }
    
    var idInt: Int {
        id ?? 0
    }
    
    var imdbIDStr: String {
        imdbID ?? ""
    }
    
    var originCountryStr: [String] {
        originCountry ?? []
    }
    
    var originalLanguageStr: String {
        originalLanguage ?? ""
    }
    
    var originalTitleStr: String {
        originalTitle ?? ""
    }
    
    var overviewStr: String {
        overview ?? ""
    }
    
    var popularityDbl: Double {
        popularity ?? 0
    }
    
    var posterPathStr: String {
        posterPath ?? ""
    }
    
    var productionCompaniesArr: [ProductionCompany] {
        productionCompanies
    }
    
    var productionCountriesArr: [ProductionCountry] {
        productionCountries
    }
    
    var releaseDateStr: String {
        releaseDate ?? ""
    }
    
    var revenueInt: Int {
        revenue ?? 0
    }
    
    var runtimeInt: Int {
        runtime ?? 0
    }
    
    var spokenLanguagesLng: [SpokenLanguage] {
        spokenLanguages
    }
    
    var statusStr: String {
        status ?? ""
    }
    
    var taglineStr: String {
        tagline ?? ""
    }
    
    var titleStr: String {
        title ?? ""
    }
    
    var videoBool: Bool {
        video ?? false
    }
    
    var voteAverageDbl: Double {
        voteAverage ?? 0
    }
    
    var voteCountInt: Int {
        voteCount ?? 0
    }
}
