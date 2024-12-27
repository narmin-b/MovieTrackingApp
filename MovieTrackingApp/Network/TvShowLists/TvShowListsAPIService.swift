//
//  TvShowListsAPIService.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 25.12.24.
//

import Foundation

final class TvShowListsAPIService: TvShowListsUseCase {
    private let apiService = CoreAPIManager.instance

    func getAiringTodayTvShows(page: Int, completion: @escaping (TvShowListsDTO?, String?) -> Void) {
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
    
    func getPopularTvShows(page: Int, completion: @escaping (TvShowListsDTO?, String?) -> Void) {
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
    
    func getTopRatedTvShows(page: Int, completion: @escaping (TvShowListsDTO?, String?) -> Void) {
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
    
    func getOnTheAirTvShows(page: Int, completion: @escaping (TvShowListsDTO?, String?) -> Void) {
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
