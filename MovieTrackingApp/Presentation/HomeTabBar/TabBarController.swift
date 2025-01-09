//
//  TabBarController.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 20.12.24.
//

import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    fileprivate func configureUI() {
        view.backgroundColor = .backgroundMain
        tabBar.backgroundColor = .accentMain
        tabBar.isTranslucent = false
        tabBar.barTintColor = .accentMain
        tabBar.tintColor = .primaryHighlight
        tabBar.unselectedItemTintColor = .lightGray
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        tabBar.layer.masksToBounds = true
        delegate = self
    }
}

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}
