//
//  TvShowListsHelper.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 25.12.24.
//

import Foundation

enum TvShowListsHelper {
    case airingToday(page: Int)
    case onTheAir(page: Int)
    case popular(page: Int)
    case topRated(page: Int)
    
    var endpoint: URL? {
        switch self {
        case .popular(let page):
            return CoreAPIHelper.instance.makeURL(path: "tv/popular?language=en-US&page=", suffix: page)
        case .airingToday(let page):
            return CoreAPIHelper.instance.makeURL(path: "tv/airing_today?language=en-US&page=", suffix: page)
        case .topRated(let page):
            return CoreAPIHelper.instance.makeURL(path: "tv/top_rated?language=en-US&page=", suffix: page)
        case .onTheAir(let page):
            return CoreAPIHelper.instance.makeURL(path: "tv/on_the_air?language=en-US&page=", suffix: page)
        }
    }
}
