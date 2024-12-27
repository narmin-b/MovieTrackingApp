//
//  PopularUseCase.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 21.12.24.
//

import Foundation

protocol MovieListsUseCase {
    func getNowPlayingMovies(page: Int, completion: @escaping(MovieListsDTO?, String?) -> Void)
    func getPopularMovies(page: Int, completion: @escaping(MovieListsDTO?, String?) -> Void)
    func getTopRatedMovies(page: Int, completion: @escaping(MovieListsDTO?, String?) -> Void)
    func getUpcomingMovies(page: Int, completion: @escaping(MovieListsDTO?, String?) -> Void)
}
