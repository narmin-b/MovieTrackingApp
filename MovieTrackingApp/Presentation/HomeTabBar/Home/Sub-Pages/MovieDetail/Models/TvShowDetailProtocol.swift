//
//  TvShowDetailProtocol.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 07.01.25.
//

import Foundation

struct TvShowDetailProtocol {
    var backdropPathStr: String
    var firstAirDateStr: String
    var genresArr: [String]
    var idInt: Int
    var languagesStrArr: [String]
    var lastAirDateStr: String
    var nameStr: String
    var numberOfEpisodesInt: Int
    var numberOfSeasonsInt: Int
    var originCountryStrArr: [String]
    var originalLanguageStr: String
    var originalNameStr: String
    var overviewStr: String
    var popularityDbl: Double
    var posterPathStr: String
    var seasonsArr: [Season]
    var spokenLanguagesArr: [SpokenLanguage]
    var typeStr: String
    var voteAverageDbl: Double
    var voteCountInt: Int 
}
