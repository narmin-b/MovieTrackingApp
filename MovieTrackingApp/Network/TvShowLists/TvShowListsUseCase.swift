//
//  TvShowListsUseCase.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 25.12.24.
//

import Foundation

protocol TvShowListsUseCase {
    func getTrendingTvShows(time: Time, completion: @escaping(TrendingTvShowDTO?, String?) -> Void)
    func getAiringTodayTvShows(page: String, completion: @escaping(TvShowListsDTO?, String?) -> Void)
    func getPopularTvShows(page: String, completion: @escaping(TvShowListsDTO?, String?) -> Void)
    func getTopRatedTvShows(page: String, completion: @escaping(TvShowListsDTO?, String?) -> Void)
    func getOnTheAirTvShows(page: String, completion: @escaping(TvShowListsDTO?, String?) -> Void)
    func getTvShowSearchResults(query: String, completion: @escaping(TvShowListsDTO?, String?) -> Void)
}
