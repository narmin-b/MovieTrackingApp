//
//  HomeCoordinator.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 20.12.24.
//

import Foundation
import UIKit.UINavigationController

final class HomeCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    deinit {
        print(#function)
    }
    
    func start() {
        let controller = HomeViewController(
            viewModel: .init(
                navigation: self,
                movieListsUse: MovieListsAPIService(),
                tvShowListsUse: TvShowListsAPIService()
            )
        )
        showController(vc: controller)
    }
}

extension HomeCoordinator: HomeNavigation {
    func showAllItems(listType: HomeListType) {
        let vc = SeeAllItemsController(
            viewModel: .init(
                listType: listType,
                navigation: self,
                tvShowListsUse: TvShowListsAPIService(),
                movieListsUse: MovieListsAPIService()
            )
        )
        vc.hidesBottomBarWhenPushed = true
        showController(vc: vc)
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
    
    func popController() {
        popControllerBack()
    }
}
