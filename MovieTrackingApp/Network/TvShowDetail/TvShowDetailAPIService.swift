//
//  TvShowDetailAPIService.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 07.01.25.
//

import Foundation

final class TvShowDetailAPIService: TvShowDetailUseCase {
    private let apiService = CoreAPIManager.instance

    func getTvShowDetail(id: String, completion: @escaping (TvShowDetailDTO?, String?) -> Void) {
        apiService.request(type: TvShowDetailDTO.self,
                           url: TvShowDetailHelper.tvshow(id: id).endpoint,
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
    
    func getTvShowVideos(id: String, completion: @escaping(TitleVideoDTO?, String?) -> Void) {
        apiService.request(type: TitleVideoDTO.self,
                           url: TvShowDetailHelper.videos(id: id).endpoint,
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
