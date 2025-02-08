//
//  GuestSessionHelper.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 15.01.25.
//

import Foundation

enum GuestSessionHelper {
    case checkGuestSession(sessionID: String)
    case createGuestSession
    case rateMovie(titleID: String, sessionID: String)
    case rateTvShow(titleID: String, sessionID: String)
    case getRatedMovies(sessionID: String)
    case getRatedTvShows(sessionID: String)
    
    var endpoint: URL? {
        switch self {
        case .checkGuestSession(let sessionId):
            return CoreAPIHelper.instance.makeURL(path: "guest_session/\(sessionId)")
        case .createGuestSession:
            return CoreAPIHelper.instance.makeURL(path: "authentication/guest_session/new")
        case .rateMovie(let titleID, let sessionId):
            return CoreAPIHelper.instance.makeURL(path: "movie/\(titleID)/rating?guest_session_id=\(sessionId)")
        case .rateTvShow(let titleID, let sessionId):
            return CoreAPIHelper.instance.makeURL(path: "tv/\(titleID)/rating?guest_session_id=\(sessionId)")
        case .getRatedMovies(let sessionId):
            return CoreAPIHelper.instance.makeURL(path: "guest_session/\(sessionId)/rated/movies")
        case .getRatedTvShows(let sessionId):
            return CoreAPIHelper.instance.makeURL(path: "guest_session/\(sessionId)/rated/tv")
        }
    }
}
