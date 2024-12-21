//
//  PopularHelper.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 21.12.24.
//

import Foundation

enum MovieListsHelper {
    case popular
    case nowPlaying
    case topRated
    case upcoming
    
    var endpoint: URL? {
        switch self {
        case .popular: return CoreAPIHelper.instance.makeURL(path: "movie/popular")
        case .nowPlaying: return CoreAPIHelper.instance.makeURL(path: "movie/now_playing")
        case .topRated: return CoreAPIHelper.instance.makeURL(path: "movie/top_rated")
        case .upcoming: return CoreAPIHelper.instance.makeURL(path: "movie/upcoming")
        }
    }
}
