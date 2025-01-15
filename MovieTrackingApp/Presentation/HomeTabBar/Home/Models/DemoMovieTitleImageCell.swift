//
//  DemoMovieTitleImageCell.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 05.01.25.
//

import Foundation

struct DemoMovieTitleImageCell{
    func mapToDomain() -> TitleImageCellProtocol {
        .init(titleString: "Test",
              imageString: "1E5baAaEse26fej7uHcjOgEE2t2.jpg",
              overviewString: "...",
              ratingString: "0",
              idInt: 0)
    }
}
