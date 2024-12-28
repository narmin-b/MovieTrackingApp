//
//  CoreAPIHelper.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 19.12.24.
//

import Foundation

enum HttpMethods: String {
    case GET
    case POST
    case PATCH
    case PUT
    case DELETE
}

final class CoreAPIHelper {
    static let instance = CoreAPIHelper()
    private init() {}
    private let baseURL = "https://api.themoviedb.org/3/"
    
    func makeURL(path: String, suffix: String) -> URL? {
        let urlString = baseURL + path + suffix
        return URL(string:urlString)
    }
    
    func makeURL(path: String) -> URL? {
        let urlString = baseURL + path
        return URL(string:urlString)
    }
    
    func makeHeader() -> [String: String] {
        return [
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJhYTQzNDllZmNhMWM5Njg3ZWVjZGFiOWM2Nzk4NDBjYyIsIm5iZiI6MTczNDUzNTUwNC42MDE5OTk4LCJzdWIiOiI2NzYyZTk1MDYzODUzNjU5YmQ0YTJjMzAiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.Ztv7OEPQu9fl2vZxRJUaQ1OEIGcnW1owZXB20wLe4dk"]
    }
}
