//
//  SearchCoordinator.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 21.12.24.
//

import Foundation
import UIKit.UINavigationController

final class SearchCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let controller = SearchViewController(
            viewModel: SearchViewModel(
                navigation: self,
                movieListsUse: MovieListsAPIService(),
                tvShowListsUse: TvShowListsAPIService()
            )
        )
        showController(vc: controller)
    }
}

extension SearchCoordinator: SearchNavigation, HomeNavigation {
    func showAllItems(listType: HomeListType) {
        return
    }
    
    func popController() {
        popControllerBack()
    }
    
    func showDetails(mediaType: MediaType, id: Int) {
        let vc = MovieDetailController(
            viewModel: .init(
                mediaType: mediaType,
                id: id,
                navigation: self,
                movieDetailsUse: MovieDetailAPIService(),
                tvShowDetailsUse: TvShowDetailAPIService(),
                guestSessionUse: GuestSessionAPIService()
            )
        )
        vc.hidesBottomBarWhenPushed = true
        showController(vc: vc)
    }
}
