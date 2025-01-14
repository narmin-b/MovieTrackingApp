//
//  TvShowListsHelper.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 25.12.24.
//

import Foundation

enum TvShowListsHelper {
    case airingToday(page: String)
    case onTheAir(page: String)
    case popular(page: String)
    case topRated(page: String)
    case trending(time: Time)
    case search(query: String, page: String)
    
    var endpoint: URL? {
        switch self {
        case .search(let query, let page):
            return CoreAPIHelper.instance.makeURL(path: "search/tv?query=\(query)&page=\(page)")
        case .trending(let time):
            return CoreAPIHelper.instance.makeURL(path: "trending/tv/\(time.rawValue)")
        case .popular(let page):
            return CoreAPIHelper.instance.makeURL(path: "tv/popular?language=en-US&page=\(page)")
        case .airingToday(let page):
            return CoreAPIHelper.instance.makeURL(path: "tv/airing_today?language=en-US&page=\(page)")
        case .topRated(let page):
            return CoreAPIHelper.instance.makeURL(path: "tv/top_rated?language=en-US&page=\(page)")
        case .onTheAir(let page):
            return CoreAPIHelper.instance.makeURL(path: "tv/on_the_air?language=en-US&page=\(page)")
        }
    }
}
