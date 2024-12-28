//
//  PopularUseCase.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 21.12.24.
//

import Foundation

protocol MovieListsUseCase {
    func getTrendingMovies(time: Time, completion: @escaping(TrendingMovieDTO?, String?) -> Void)
    func getNowPlayingMovies(page: String, completion: @escaping(MovieListsDTO?, String?) -> Void)
    func getPopularMovies(page: String, completion: @escaping(MovieListsDTO?, String?) -> Void)
    func getTopRatedMovies(page: String, completion: @escaping(MovieListsDTO?, String?) -> Void)
    func getUpcomingMovies(page: String, completion: @escaping(MovieListsDTO?, String?) -> Void)
}
