//
//  PopularTvShowDTO.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 25.12.24.
//

import Foundation

// MARK: - PopularTvShowDTO
struct PopularTvShowDTO: Codable {
    let page: Int
    let results: [TvShowResultDTO]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
