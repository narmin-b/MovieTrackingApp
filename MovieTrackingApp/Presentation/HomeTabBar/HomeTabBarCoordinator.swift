////
////  HomeTabBarCoordinator.swift
////  MovieTrackingApp
////
////  Created by Narmin Baghirova on 20.12.24.
////
//
//import UIKit
//
//final class HomeTabBarCoordinator: Coordinator {
//    weak var parentCoordinator: Coordinator?
//    var children: [Coordinator] = []
//    var navigationController: UINavigationController
//    private let window: UIWindow
//    
//    private let tabBarController = TabBarController()
//    private var homeCoordinator: HomeCoordinator?
//    private var favoriteCoordinator: FavoriteCoordinator?
//    private var searchCoordinator: SearchCoordinator?
//    private var profileCoordinator: ProfileCoordinator?
//    
//    init(
//        window: UIWindow,
//        navigationController: UINavigationController
//    ) {
//        self.window = window
//        self.navigationController = navigationController
//    }
//    
//    func start() {
//        initializeHomeTabBar()
//    }
//    
//    deinit {
//        print("tabbar")
//    }
//    
//    private func initializeHomeTabBar() {
//        let homeNavigationController = UINavigationController()
//        homeCoordinator = HomeCoordinator(navigationController: homeNavigationController)
//        homeCoordinator?.parentCoordinator = parentCoordinator
//        
//        let favoriteNavigationController = UINavigationController()
//        favoriteCoordinator = FavoriteCoordinator(navigationController: favoriteNavigationController)
//        favoriteCoordinator?.parentCoordinator = parentCoordinator
//        
//        let searchNavigationController = UINavigationController()
//        searchCoordinator = SearchCoordinator(navigationController: searchNavigationController)
//        searchCoordinator?.parentCoordinator = parentCoordinator
//        
//        let profileNavigationController = UINavigationController()
//        profileCoordinator = ProfileCoordinator(window: window, navigationController: profileNavigationController)
//        profileCoordinator?.parentCoordinator = parentCoordinator
//        
//        let homeItem = UITabBarItem()
//        homeItem.image = UIImage(systemName: "house")
//        homeItem.selectedImage = UIImage(systemName: "house.fill")
//        homeNavigationController.tabBarItem = homeItem
//        homeNavigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        homeNavigationController.navigationBar.shadowImage = UIImage()
//        
//        let favoriteItem = UITabBarItem()
//        favoriteItem.image = UIImage(systemName: "heart")
//        favoriteItem.selectedImage = UIImage(systemName: "heart.fill")
//        favoriteNavigationController.tabBarItem = favoriteItem
//        
//        let searchItem = UITabBarItem()
//        searchItem.image = UIImage(systemName: "magnifyingglass")
//        searchItem.selectedImage = UIImage(systemName: "magnifyingglass")
//        searchNavigationController.tabBarItem = searchItem
//        
//        let profileItem = UITabBarItem()
//        profileItem.image = UIImage(systemName: "person")
//        profileItem.selectedImage = UIImage(systemName: "person.fill")
//        profileNavigationController.tabBarItem = profileItem
//        
//        tabBarController.viewControllers = [
//            homeNavigationController,
//            searchNavigationController,
//            favoriteNavigationController,
//            profileNavigationController
//        ]
//        
//        navigationController.setViewControllers([tabBarController], animated: false)
//        navigationController.setNavigationBarHidden(true, animated: false)
//        
//        parentCoordinator?.children.append (
//            homeCoordinator ?? HomeCoordinator(navigationController: UINavigationController())
//        )
//        
//        parentCoordinator?.children.append (
//            favoriteCoordinator ?? FavoriteCoordinator(navigationController: UINavigationController())
//        )
//        
//        parentCoordinator?.children.append (
//            searchCoordinator ?? SearchCoordinator(navigationController: UINavigationController())
//        )
//        
//        parentCoordinator?.children.append (
//            profileCoordinator ?? ProfileCoordinator(window: window, navigationController: UINavigationController())
//        )
//        
//        homeCoordinator?.start()
//        favoriteCoordinator?.start()
//        profileCoordinator?.start()
//        searchCoordinator?.start()
//    }
//}

// HomeTabBarCoordinator.swift

import UIKit

final class HomeTabBarCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController // Use this for the TabBar
    private let window: UIWindow

    private let tabBarController = TabBarController()
    private var homeCoordinator: HomeCoordinator?
    private var favoriteCoordinator: FavoriteCoordinator?
    private var searchCoordinator: SearchCoordinator?
    private var profileCoordinator: ProfileCoordinator?

    init(window: UIWindow, navigationController: UINavigationController) {
        self.window = window
        self.navigationController = navigationController  // Store the NavigationController
    }

    func start() {
        print("HomeTabBarCoordinator.start() called")
        initializeHomeTabBar()
        
        navigationController.setViewControllers([tabBarController], animated: false) 
    }

    deinit {
        print("tabbar")
    }

    private func initializeHomeTabBar() {
        print("initializeHomeTabBar() called")
        
        let homeNavigationController = UINavigationController()
        homeCoordinator = HomeCoordinator(navigationController: homeNavigationController)
        homeCoordinator?.parentCoordinator = self
        children.append(homeCoordinator!)  // Append to children

        let favoriteNavigationController = UINavigationController()
        favoriteCoordinator = FavoriteCoordinator(navigationController: favoriteNavigationController)
        favoriteCoordinator?.parentCoordinator = self
        children.append(favoriteCoordinator!)

        let searchNavigationController = UINavigationController()
        searchCoordinator = SearchCoordinator(navigationController: searchNavigationController)
        searchCoordinator?.parentCoordinator = self
        children.append(searchCoordinator!)

        let profileNavigationController = UINavigationController()
        profileCoordinator = ProfileCoordinator(window: window, navigationController: profileNavigationController)
        profileCoordinator?.parentCoordinator = self
        children.append(profileCoordinator!)

        let homeItem = UITabBarItem()
        homeItem.image = UIImage(systemName: "house")
        homeItem.selectedImage = UIImage(systemName: "house.fill")
        homeNavigationController.tabBarItem = homeItem
        homeNavigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        homeNavigationController.navigationBar.shadowImage = UIImage()

        let favoriteItem = UITabBarItem()
        favoriteItem.image = UIImage(systemName: "heart")
        favoriteItem.selectedImage = UIImage(systemName: "heart.fill")
        favoriteNavigationController.tabBarItem = favoriteItem

        let searchItem = UITabBarItem()
        searchItem.image = UIImage(systemName: "magnifyingglass")
        searchItem.selectedImage = UIImage(systemName: "magnifyingglass")
        searchNavigationController.tabBarItem = searchItem

        let profileItem = UITabBarItem()
        profileItem.image = UIImage(systemName: "person")
        profileItem.selectedImage = UIImage(systemName: "person.fill")
        profileNavigationController.tabBarItem = profileItem

        tabBarController.viewControllers = [
            homeNavigationController,
            searchNavigationController,
            favoriteNavigationController,
            profileNavigationController
        ]
        
        print("tabBarController.viewControllers: \(tabBarController.viewControllers)")
        
        // No longer pushing the TabBarController onto the navigationController
        // We are setting it as the root view controller in AppCoordinator now.

        homeCoordinator?.start()
        favoriteCoordinator?.start()
        profileCoordinator?.start()
        searchCoordinator?.start()
    }
}
