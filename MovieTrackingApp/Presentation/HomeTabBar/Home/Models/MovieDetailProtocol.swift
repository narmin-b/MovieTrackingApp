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
    var genreIDSInt: [Int] {get}
    var idInt: Int {get}
    var originalLanguageStr: String {get}
    var originalTitleStr: String {get}
    var overviewStr: String {get}
    var popularityDbl: Double {get}
    var posterPathStr: String {get}
    var releaseDateStr: String {get}
    var titleStr: String {get}
    var videoBool: Bool {get}
    var voteAverageDbl: Double {get}
    var voteCountInt: Int {get}
}

