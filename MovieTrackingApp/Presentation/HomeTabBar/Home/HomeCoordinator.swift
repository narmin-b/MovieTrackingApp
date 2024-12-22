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
    
    func start() {
        let controller = HomeViewController(viewModel: .init(navigation: self))
        showController(vc: controller)
    }
}

extension HomeCoordinator: HomeNavigation {
    func showAllItems(movieList: [MovieResultDTO]) {
        let vc = SeeAllItemsController(viewModel: .init(movieList: movieList))
        showController(vc: vc)
    }
    
    func showDetails() {
        let vc = MovieDetailController(viewModel: .init())
        showController(vc: vc)
    }
}
