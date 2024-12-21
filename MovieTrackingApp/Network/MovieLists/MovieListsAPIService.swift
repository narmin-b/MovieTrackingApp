//
//  PopularAPIService.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 21.12.24.
//

import Foundation

final class MovieListsAPIService: MovieListsUseCase {
    private let apiService = CoreAPIManager.instance
    
    func getNowPlayingMovies(completion: @escaping (NowPlayingDTO?, String?) -> Void) {
        apiService.request(type: NowPlayingDTO.self,
                           url: MovieListsHelper.nowPlaying.endpoint,
                           method: .GET) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                completion(data, nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func getPopularMovies(completion: @escaping (PopularMoviesDTO?, String?) -> Void) {
        apiService.request(type: PopularMoviesDTO.self,
                           url: MovieListsHelper.popular.endpoint,
                           method: .GET) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                completion(data, nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func getTopRatedMovies(completion: @escaping (TopRatedMoviesDTO?, String?) -> Void) {
        apiService.request(type: TopRatedMoviesDTO.self,
                           url: MovieListsHelper.topRated.endpoint,
                           method: .GET) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                completion(data, nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func getUpcomingMovies(completion: @escaping (UpcomingMoviesDTO?, String?) -> Void) {
        apiService.request(type: UpcomingMoviesDTO.self,
                           url: MovieListsHelper.upcoming.endpoint,
                           method: .GET) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                completion(data, nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
}
