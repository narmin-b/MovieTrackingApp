//
//  PopularAPIService.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 21.12.24.
//

import Foundation

final class MovieListsAPIService: MovieListsUseCase {
    private let apiService = CoreAPIManager.instance
    
    func getTrendingMovies(time: Time, completion: @escaping (TrendingMovieDTO?, String?) -> Void) {
        apiService.request(type: TrendingMovieDTO.self,
                          url: MovieListsHelper.trending(time: time).endpoint,
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
    
    func getNowPlayingMovies(page: String, completion: @escaping (MovieListsDTO?, String?) -> Void) {
        apiService.request(type: MovieListsDTO.self,
                           url: MovieListsHelper.nowPlaying(page: page).endpoint,
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
    
    func getPopularMovies(page: String, completion: @escaping (MovieListsDTO?, String?) -> Void) {
        apiService.request(type: MovieListsDTO.self,
                           url: MovieListsHelper.popular(page: page).endpoint,
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
    
    func getTopRatedMovies(page: String, completion: @escaping (MovieListsDTO?, String?) -> Void) {
        apiService.request(type: MovieListsDTO.self,
                           url: MovieListsHelper.topRated(page: page).endpoint,
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
    
    func getUpcomingMovies(page: String, completion: @escaping (MovieListsDTO?, String?) -> Void) {
        apiService.request(type: MovieListsDTO.self,
                           url: MovieListsHelper.upcoming(page: page).endpoint,
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
}
