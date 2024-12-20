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
        
        let homeItem = UITabBarItem()
        homeItem.title = "Home"
        homeItem.image = UIImage(systemName: "house")
        homeItem.selectedImage = UIImage(systemName: "house.fill")
        homeNavigationController.tabBarItem = homeItem
        
        tabBarController.viewControllers = [
            homeNavigationController
        ]
        
        navigationController.pushViewController(tabBarController, animated: true)
        
        parentCoordinator?.children.append (
            homeCoordinator ?? HomeCoordinator(navigationController: UINavigationController())
        )
        
        homeCoordinator?.start()
    }
}
