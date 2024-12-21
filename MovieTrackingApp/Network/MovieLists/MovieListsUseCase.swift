//
//  PopularUseCase.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 21.12.24.
//

import Foundation

protocol MovieListsUseCase {
    func getNowPlayingMovies(completion: @escaping(NowPlayingDTO?, String?) -> Void)
    func getPopularMovies(completion: @escaping(PopularMoviesDTO?, String?) -> Void)
    func getTopRatedMovies(completion: @escaping(TopRatedMoviesDTO?, String?) -> Void)
    func getUpcomingMovies(completion: @escaping(UpcomingMoviesDTO?, String?) -> Void)
}
