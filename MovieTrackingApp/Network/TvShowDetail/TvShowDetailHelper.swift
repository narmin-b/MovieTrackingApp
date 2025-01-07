//
//  TvShowDetailHelper.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 07.01.25.
//

import Foundation

enum TvShowDetailHelper {
    case tvshow(id: String)
    
    var endpoint: URL? {
        switch self {
        case .tvshow(let id):
            return CoreAPIHelper.instance.makeURL(path: "tv/", suffix: id)
        }
    }
}
