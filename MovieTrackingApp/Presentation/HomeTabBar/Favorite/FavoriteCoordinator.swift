//
//  FavoriteCoordinator.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 20.12.24.
//

import Foundation
import UIKit.UINavigationController

final class FavoriteCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let controller = FavoriteViewController(viewModel: FavoriteViewModel(navigation: self))
        showController(vc: controller)
    }
}

extension FavoriteCoordinator: FavoriteNavigation {
    func showDetails(mediaType: MediaType, id: Int) {
        let vc = MovieDetailController(viewModel: .init(mediaType: mediaType, id: id))
        vc.hidesBottomBarWhenPushed = true
        showController(vc: vc)
    }
}
