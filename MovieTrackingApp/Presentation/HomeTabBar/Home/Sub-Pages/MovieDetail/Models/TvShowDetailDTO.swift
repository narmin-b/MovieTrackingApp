//
//  TvShowDetailDTO.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 07.01.25.
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let tvShowDetailDTO = try? JSONDecoder().decode(TvShowDetailDTO.self, from: jsonData)

import Foundation

// MARK: - TvShowDetailDTO
struct TvShowDetailDTO: Codable {
    let adult: Bool?
    let backdropPath: String?
    let createdBy: [CreatedBy]?
    let episodeRunTime: [Int]?
    let firstAirDate: String?
    let genres: [Genre]?
    let homepage: String?
    let id: Int?
    let inProduction: Bool?
    let languages: [String]?
    let lastAirDate: String?
    let lastEpisodeToAir: TEpisodeToAir?
    let name: String?
    let nextEpisodeToAir: TEpisodeToAir?
    let networks: [Network]?
    let numberOfEpisodes, numberOfSeasons: Int?
    let originCountry: [String]?
    let originalLanguage, originalName, overview: String?
    let popularity: Double?
    let posterPath: String?
    let productionCompanies: [Network]?
    let productionCountries: [ProductionCountry]?
    let seasons: [Season]?
    let spokenLanguages: [SpokenLanguage]?
    let status, tagline, type: String?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case createdBy = "created_by"
        case episodeRunTime = "episode_run_time"
        case firstAirDate = "first_air_date"
        case genres, homepage, id
        case inProduction = "in_production"
        case languages
        case lastAirDate = "last_air_date"
        case lastEpisodeToAir = "last_episode_to_air"
        case name
        case nextEpisodeToAir = "next_episode_to_air"
        case networks
        case numberOfEpisodes = "number_of_episodes"
        case numberOfSeasons = "number_of_seasons"
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case overview, popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case seasons
        case spokenLanguages = "spoken_languages"
        case status, tagline, type
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

// MARK: - CreatedBy
struct CreatedBy: Codable {
    let id: Int?
    let creditID, name, originalName: String?
    let gender: Int?
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case creditID = "credit_id"
        case name
        case originalName = "original_name"
        case gender
        case profilePath = "profile_path"
    }
}

// MARK: - TEpisodeToAir
struct TEpisodeToAir: Codable {
    let id: Int?
    let name, overview: String?
    let voteAverage: Double?
    let voteCount: Int?
    let airDate: String?
    let episodeNumber: Int?
    let episodeType, productionCode: String?
    let runtime: Int?
    let seasonNumber, showID: Int?
    let stillPath: String?

    enum CodingKeys: String, CodingKey {
        case id, name, overview
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case airDate = "air_date"
        case episodeNumber = "episode_number"
        case episodeType = "episode_type"
        case productionCode = "production_code"
        case runtime
        case seasonNumber = "season_number"
        case showID = "show_id"
        case stillPath = "still_path"
    }
}

// MARK: - Network
struct Network: Codable {
    let id: Int?
    let logoPath: String?
    let name: String?
    let originCountry: String?

    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
}

// MARK: - Season
struct Season: Codable {
    let airDate: String?
    let episodeCount, id: Int?
    let name, overview: String?
    let posterPath: String?
    let seasonNumber, voteAverage: Int?

    enum CodingKeys: String, CodingKey {
        case airDate = "air_date"
        case episodeCount = "episode_count"
        case id, name, overview
        case posterPath = "poster_path"
        case seasonNumber = "season_number"
        case voteAverage = "vote_average"
    }
}

extension TvShowDetailDTO: TvShowDetailProtocol {
    var backdropPathStr: String {
        backdropPath ?? ""
    }
    
    var createdByArr: [CreatedBy] {
        createdBy ?? []
    }
    
    var episodeRunTimeIntArr: [Int] {
        episodeRunTime ?? []
    }
    
    var firstAirDateStr: String {
        firstAirDate ?? ""
    }
    
    var genresArr: [String] {
        genres?.map { $0.name ?? "" } ?? []
    }
    
    var idInt: Int {
        id ?? 0
    }
    
    var languagesStrArr: [String] {
        languages ?? []
    }
    
    var lastAirDateStr: String {
        lastAirDate ?? ""
    }
    
    var lastEpisodeToAirCst: TEpisodeToAir {
        lastEpisodeToAir ?? TEpisodeToAir(
                id: nil,
                name: nil,
                overview: nil,
                voteAverage: nil,
                voteCount: nil,
                airDate: nil,
                episodeNumber: nil,
                episodeType: nil,
                productionCode: nil,
                runtime: nil,
                seasonNumber: nil,
                showID: nil,
                stillPath: nil
            )
    }
    
    var nameStr: String {
        name ?? ""
    }
    
    var nextEpisodeToAirCst: TEpisodeToAir {
        nextEpisodeToAir ?? TEpisodeToAir(
            id: nil,
            name: nil,
            overview: nil,
            voteAverage: nil,
            voteCount: nil,
            airDate: nil,
            episodeNumber: nil,
            episodeType: nil,
            productionCode: nil,
            runtime: nil,
            seasonNumber: nil,
            showID: nil,
            stillPath: nil
        )
    }
    
    var networksArr: [Network] {
        networks ?? []
    }
    
    var numberOfEpisodesInt: Int {
        numberOfEpisodes ?? 0
    }
    
    var numberOfSeasonsInt: Int {
        numberOfSeasons ?? 0
    }
    
    var originCountryStrArr: [String] {
        originCountry ?? []
    }
    
    var originalLanguageStr: String {
        originalLanguage ?? ""
    }
    
    var originalNameStr: String {
        originalName ?? ""
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
    
    var productionCompaniesArr: [Network] {
        productionCompanies ?? []
    }
    
    var productionCountriesArr: [ProductionCountry] {
        productionCountries ?? []
    }
    
    var seasonsArr: [Season] {
        seasons ?? []
    }
    
    var spokenLanguagesArr: [SpokenLanguage] {
        spokenLanguages ?? []
    }
    
    var statusStr: String {
        status ?? ""
    }
    
    var taglineStr: String {
        tagline ?? ""
    }
    
    var typeStr: String {
        type ?? ""
    }
    
    var voteAverageDbl: Double {
        voteAverage ?? 0
    }
    
    var voteCountInt: Int {
        voteCount ?? 0
    }
}
