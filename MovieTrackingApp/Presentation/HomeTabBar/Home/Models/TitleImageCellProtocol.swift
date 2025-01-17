//
//  TitleImageCellProtocol.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 21.12.24.
//

import Foundation

struct TitleImageCellProtocol {
    var titleString: String
    var imageString: String
    var overviewString: String
    var voteString: String
    var idInt: Int
}

struct TitleImageCellWithRatingProtocol {
    var titleString: String
    var imageString: String
    var overviewString: String
    var voteString: String
    var idInt: Int
    var ratingString: String
}
