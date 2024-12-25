//
//  MovieDetailProtocol.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 23.12.24.
//

import Foundation

protocol MovieDetailProtocol {
    var adultBool: Bool {get}
    var backdropPathStr: String {get}
    var belongsToCollectionArr: BelongsToCollection {get}
    var budgetInt: Int {get}
    var genresArr: [String] {get}
    var homepageStr: String {get}
    var idInt: Int {get}
    var imdbIDStr: String {get}
    var originCountryStr: [String] {get}
    var originalLanguageStr: String {get}
    var originalTitleStr: String {get}
    var overviewStr: String {get}
    var popularityDbl: Double {get}
    var posterPathStr: String {get}
    var productionCompaniesArr: [ProductionCompany] {get}
    var productionCountriesArr: [ProductionCountry] {get}
    var releaseDateStr: String {get}
    var revenueInt: Int {get}
    var runtimeInt: Int {get}
    var spokenLanguagesLng: [SpokenLanguage] {get}
    var statusStr: String {get}
    var taglineStr: String {get}
    var titleStr: String {get}
    var videoBool: Bool {get}
    var voteAverageDbl: Double {get}
    var voteCountInt: Int {get}
}
