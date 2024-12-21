//
//  HomeTabBarCoordinator.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 20.12.24.
//

import UIKit

final class HomeTabBarCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    private let tabBarController = TabBarController()
    private var homeCoordinator: HomeCoordinator?
    private var favoriteCoordinator: FavoriteCoordinator?
    
    init(
        navigationController: UINavigationController
    ) {
        self.navigationController = navigationController
    }
    
    func start() {
        initializeHomeTabBar()
    }
    
    deinit {
        print(#function)
    }
    
    private func initializeHomeTabBar() {
        let homeNavigationController = UINavigationController()
        homeCoordinator = HomeCoordinator(navigationController: homeNavigationController)
        homeCoordinator?.parentCoordinator = parentCoordinator
        
        let favoriteNavigationController = UINavigationController()
        favoriteCoordinator = FavoriteCoordinator(navigationController: favoriteNavigationController)
        favoriteCoordinator?.parentCoordinator = parentCoordinator
        
        let homeItem = UITabBarItem()
        homeItem.title = "Home"
        homeItem.image = UIImage(systemName: "house")
        homeItem.selectedImage = UIImage(systemName: "house.fill")
        homeNavigationController.tabBarItem = homeItem
        
        let favoriteItem = UITabBarItem()
        favoriteItem.title = "Favorites"
        favoriteItem.image = UIImage(systemName: "heart")
        favoriteItem.selectedImage = UIImage(systemName: "heart.fill")
        favoriteNavigationController.tabBarItem = favoriteItem
        
        tabBarController.viewControllers = [
            homeNavigationController,
            favoriteNavigationController
        ]
        
        navigationController.pushViewController(tabBarController, animated: true)
        navigationController.setNavigationBarHidden(true, animated: false)
        
        parentCoordinator?.children.append (
            homeCoordinator ?? HomeCoordinator(navigationController: UINavigationController())
        )
        
        parentCoordinator?.children.append (
            favoriteCoordinator ?? FavoriteCoordinator(navigationController: UINavigationController())
        )
        
        homeCoordinator?.start()
        favoriteCoordinator?.start()
    }
}
