//
//  TitleVideoDTO.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 14.01.25.
//

import Foundation

// MARK: - TitleVideoDTO
struct TitleVideoDTO: Codable {
    let id: Int
    let results: [VideoResult]
}

// MARK: - Result
struct VideoResult: Codable {
    let iso639_1: String
    let iso3166_1: String
    let name, key: String
    let site: Site
    let size: Int
    let type: TypeEnum
    let official: Bool
    let publishedAt, id: String

    enum CodingKeys: String, CodingKey {
        case iso639_1 = "iso_639_1"
        case iso3166_1 = "iso_3166_1"
        case name, key, site, size, type, official
        case publishedAt = "published_at"
        case id
    }
}

enum Site: String, Codable {
    case youTube = "YouTube"
}

enum TypeEnum: String, Codable {
    case behindTheScenes = "Behind the Scenes"
    case clip = "Clip"
    case featurette = "Featurette"
    case teaser = "Teaser"
    case trailer = "Trailer"
}

extension TitleVideoDTO: TitleVideoProtocol {
    var videoId: String {
        results.first(where: { $0.type == .trailer })?.key ?? ""
    }
}
