//
//  PopularHelper.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 21.12.24.
//

import Foundation

enum MovieListsHelper {
    case popular(page: String)
    case nowPlaying(page: String)
    case topRated(page: String)
    case upcoming(page: String)
    case trending(time: Time)
    case search(query: String)
    
    var endpoint: URL? {
        switch self {
        case .search(let query):
            return CoreAPIHelper.instance.makeURL(path: "search/movie?query=", suffix: query)
        case .trending(let time):
            return CoreAPIHelper.instance.makeURL(path: "trending/movie/", suffix: time.rawValue)
        case .popular(let page):
            return CoreAPIHelper.instance.makeURL(path: "movie/popular?language=en-US&page=", suffix: page)
        case .nowPlaying(let page):
            return CoreAPIHelper.instance.makeURL(path: "movie/now_playing?language=en-US&page=", suffix: page)
        case .topRated(let page):
            return CoreAPIHelper.instance.makeURL(path: "movie/top_rated?language=en-US&page=", suffix: page)
        case .upcoming(let page):
            return CoreAPIHelper.instance.makeURL(path: "movie/upcoming?language=en-US&page=", suffix: page)
        }
    }
}
