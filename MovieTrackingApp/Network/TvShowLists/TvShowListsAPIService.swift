//
//  TvShowListsAPIService.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 25.12.24.
//

import Foundation

final class TvShowListsAPIService: TvShowListsUseCase {
    private let apiService = CoreAPIManager.instance
    
    func getTvShowSearchResults(query: String, page: String, completion: @escaping (TvShowListsDTO?, String?) -> Void) {
        apiService.request(type: TvShowListsDTO.self,
                           url: TvShowListsHelper.search(query: query, page: page).endpoint,
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
    
    func getTrendingTvShows(time: Time, completion: @escaping(TrendingTvShowDTO?, String?) -> Void) {
        apiService.request(type: TrendingTvShowDTO.self,
                           url: TvShowListsHelper.trending(time: time).endpoint,
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

    func getAiringTodayTvShows(page: String, completion: @escaping (TvShowListsDTO?, String?) -> Void) {
        apiService.request(type: TvShowListsDTO.self,
                           url: TvShowListsHelper.airingToday(page: page).endpoint,
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
    
    func getPopularTvShows(page: String, completion: @escaping (TvShowListsDTO?, String?) -> Void) {
        apiService.request(type: TvShowListsDTO.self,
                           url: TvShowListsHelper.popular(page: page).endpoint,
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
    
    func getTopRatedTvShows(page: String, completion: @escaping (TvShowListsDTO?, String?) -> Void) {
        apiService.request(type: TvShowListsDTO.self,
                           url: TvShowListsHelper.topRated(page: page).endpoint,
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
    
    func getOnTheAirTvShows(page: String, completion: @escaping (TvShowListsDTO?, String?) -> Void) {
        apiService.request(type: TvShowListsDTO.self,
                           url: TvShowListsHelper.onTheAir(page: page).endpoint,
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
