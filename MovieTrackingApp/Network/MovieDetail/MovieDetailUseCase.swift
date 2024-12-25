//
//  MovieDetailUseCase.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 24.12.24.
//

import Foundation

protocol MovieDetailUseCase {
    func getMovieDetail(id: Int, completion: @escaping(MovieDetailDTO?, String?) -> Void)
}
