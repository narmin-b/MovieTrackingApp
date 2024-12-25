//
//  TvShowListsUseCase.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 25.12.24.
//

import Foundation

protocol TvShowListsUseCase {
    func getAiringTodayTvShows(page: Int, completion: @escaping(AiringTodayDTO?, String?) -> Void)
    func getPopularTvShows(page: Int, completion: @escaping(PopularTvShowDTO?, String?) -> Void)
    func getTopRatedTvShows(page: Int, completion: @escaping(TopRatedTvShowDTO?, String?) -> Void)
    func getOnTheAirTvShows(page: Int, completion: @escaping(OnTheAirDTO?, String?) -> Void)
}
