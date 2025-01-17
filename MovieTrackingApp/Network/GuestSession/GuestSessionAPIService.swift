//
//  MovieDetailAPIService.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 24.12.24.
//

import Foundation

final class GuestSessionAPIService: GuestSessionUseCase {
    private let apiService = CoreAPIManager.instance
    
    func getRatedMovies(id: String, completion: @escaping (RatedMovieListsDTO?, String?) -> Void) {
        apiService.request(type: RatedMovieListsDTO.self,
                           url: GuestSessionHelper.getRatedMovies(sessionID: id).endpoint,
                           method: .GET) { [weak self] result in
            guard let _ = self else { return }
            switch result {
            case .success(let data):
                completion(data, nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func getRatedTvShows(id: String, completion: @escaping (RatedTvShowsDTO?, String?) -> Void) {
        apiService.request(type: RatedTvShowsDTO.self,
                           url: GuestSessionHelper.getRatedTvShows(sessionID: id).endpoint,
                           method: .GET) { [weak self] result in
            guard let _ = self else { return }
            switch result {
            case .success(let data):
                completion(data, nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func createGuestSessiontoken(completion: @escaping (GuestSessionDTO?, String?) -> Void) {
        apiService.request(type: GuestSessionDTO.self,
                           url: GuestSessionHelper.createGuestSession.endpoint,
                           method: .GET) { [weak self] result in
            guard let _ = self else { return }
            switch result {
            case .success(let data):
                completion(data, nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func rateTvShow(titleID: String, sessionID: String, rating: Int, completion: @escaping (POSTSuccessDTO?, String?) -> Void) {
        apiService.request(type: POSTSuccessDTO.self,
                           url: GuestSessionHelper.rateTvShow(titleID: titleID, sessionID: sessionID).endpoint,
                           method: .POST,
                           header: ["Content-Type" : "application/json;charset=utf-8"],
                           body: ["value" : rating]
        ) { [weak self] result in
            guard let _ = self else { return }
            switch result {
            case .success(let data):
                completion(data, nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func rateMovie(titleID: String, sessionID: String, rating: Int, completion: @escaping (POSTSuccessDTO?, String?) -> Void) {
        apiService.request(type: POSTSuccessDTO.self,
                           url: GuestSessionHelper.rateMovie(titleID: titleID, sessionID: sessionID).endpoint,
                           method: .POST,
                           header: ["Content-Type" : "application/json;charset=utf-8"],
                           body: ["value" : rating]
        ) { [weak self] result in
            guard let _ = self else { return }
            switch result {
            case .success(let data):
                completion(data, nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
}
