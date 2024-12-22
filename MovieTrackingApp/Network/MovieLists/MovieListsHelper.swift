//
//  PopularHelper.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 21.12.24.
//

import Foundation

enum MovieListsHelper {
    case popular(page: Int)
    case nowPlaying(page: Int)
    case topRated(page: Int)
    case upcoming(page: Int)
    
    var endpoint: URL? {
        switch self {
        case .popular(let page):
            return CoreAPIHelper.instance.makeURL(path: "movie/popular?language=en-US&page=", page: page)
        case .nowPlaying(let page):
            return CoreAPIHelper.instance.makeURL(path: "movie/now_playing?language=en-US&page=", page: page)
        case .topRated(let page):
            return CoreAPIHelper.instance.makeURL(path: "movie/top_rated?language=en-US&page=", page: page)
        case .upcoming(let page):
            return CoreAPIHelper.instance.makeURL(path: "movie/upcoming?language=en-US&page=", page: page)
        }
    }
}
