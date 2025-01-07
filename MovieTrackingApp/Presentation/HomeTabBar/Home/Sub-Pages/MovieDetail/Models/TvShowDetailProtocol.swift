//
//  TvShowDetailProtocol.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 07.01.25.
//

import Foundation

protocol TvShowDetailProtocol {
    var backdropPathStr: String {get}
    var createdByArr: [CreatedBy] {get}
    var episodeRunTimeIntArr: [Int] {get}
    var firstAirDateStr: String {get}
    var genresArr: [String] {get}
    var idInt: Int {get}
    var languagesStrArr: [String] {get}
    var lastAirDateStr: String {get}
    var lastEpisodeToAirCst: TEpisodeToAir {get}
    var nameStr: String {get}
    var nextEpisodeToAirCst: TEpisodeToAir {get}
    var networksArr: [Network] {get}
    var numberOfEpisodesInt: Int {get}
    var numberOfSeasonsInt: Int {get}
    var originCountryStrArr: [String] {get}
    var originalLanguageStr: String {get}
    var originalNameStr: String {get}
    var overviewStr: String {get}
    var popularityDbl: Double {get}
    var posterPathStr: String {get}
    var productionCompaniesArr: [Network] {get}
    var productionCountriesArr: [ProductionCountry] {get}
    var seasonsArr: [Season] {get}
    var spokenLanguagesArr: [SpokenLanguage] {get}
    var statusStr: String {get}
    var taglineStr: String {get}
    var typeStr: String {get}
    var voteAverageDbl: Double {get}
    var voteCountInt: Int {get}
}
