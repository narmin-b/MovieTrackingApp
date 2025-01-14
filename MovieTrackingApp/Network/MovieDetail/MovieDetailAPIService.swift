//
//  MovieDetailAPIService.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 24.12.24.
//

import Foundation

final class MovieDetailAPIService: MovieDetailUseCase {
    private let apiService = CoreAPIManager.instance

    func getMovieDetail(id: String, completion: @escaping (MovieDetailDTO?, String?) -> Void) {
        apiService.request(type: MovieDetailDTO.self,
                           url: MovieDetailHelper.movie(id: id).endpoint,
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
    
    func getMovieVideos(id: String, completion: @escaping(TitleVideoDTO?, String?) -> Void) {
        apiService.request(type: TitleVideoDTO.self,
                           url: MovieDetailHelper.videos(id: id).endpoint,
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
