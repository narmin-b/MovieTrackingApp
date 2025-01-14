//
//  TvShowDetailUseCase.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 07.01.25.
//

import Foundation

protocol TvShowDetailUseCase {
    func getTvShowDetail(id: String, completion: @escaping(TvShowDetailDTO?, String?) -> Void)
    func getTvShowVideos(id: String, completion: @escaping(TitleVideoDTO?, String?) -> Void)
}
