//
//  PopularMoviesDTO.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 21.12.24.
//

import Foundation

// MARK: - PopularMoviesDTO
struct MovieListsDTO: Codable {
    let page: Int
    let results: [MovieResultDTO]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
