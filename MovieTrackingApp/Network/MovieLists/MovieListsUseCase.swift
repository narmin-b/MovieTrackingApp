//
//  PopularUseCase.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 21.12.24.
//

import Foundation

protocol MovieListsUseCase {
    func getNowPlayingMovies(page: Int, completion: @escaping(NowPlayingDTO?, String?) -> Void)
    func getPopularMovies(page: Int, completion: @escaping(PopularMoviesDTO?, String?) -> Void)
    func getTopRatedMovies(page: Int, completion: @escaping(TopRatedMoviesDTO?, String?) -> Void)
    func getUpcomingMovies(page: Int, completion: @escaping(UpcomingMoviesDTO?, String?) -> Void)
}
