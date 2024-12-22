//
//  UpcomingMoviesDTO.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 21.12.24.
//

import Foundation

// MARK: - UpcomingMoviesDTO
struct UpcomingMoviesDTO: Codable {
    let dates: ReleaseDates
    let page: Int
    let results: [MovieResultDTO]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Dates
struct ReleaseDates: Codable {
    let maximum, minimum: String
}
