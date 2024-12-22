//
//  SeeAllItemsViewModel.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 19.12.24.
//

import Foundation

final class SeeAllItemsViewModel {
    enum ViewState {
        case loading
        case loaded
        case success
        case error(message: String)
    }
    
    var requestCallback : ((ViewState) -> Void?)?
    private let movieList: [MovieResultDTO]
    
    init(movieList: [MovieResultDTO]) {
        self.movieList = movieList
    }
    
    func getAllItems() -> Int {
        return movieList.count
    }
    
    func getAllItemsProtocol(index: Int) -> TitleImageCellProtocol? {
        return movieList[index]
    }
}
