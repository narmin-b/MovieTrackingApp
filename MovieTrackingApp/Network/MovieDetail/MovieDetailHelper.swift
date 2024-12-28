//
//  MovieDetailHelper.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 24.12.24.
//

import Foundation

enum MovieDetailHelper {
    case movie(id: String)
    
    var endpoint: URL? {
        switch self {
        case .movie(let id):
            return CoreAPIHelper.instance.makeURL(path: "movie/", suffix: id)
        }
    }
}
