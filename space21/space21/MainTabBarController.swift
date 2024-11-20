//
//  MainTabBarController.swift
//  space21
//
//  Created by Марина on 16.10.2024.
//

import UIKit
class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let feedVC = UINavigationController(rootViewController: FeedViewController())
        let searchVC = UINavigationController(rootViewController: SearchViewController())
        let profileVC = UINavigationController(rootViewController: ProfileViewController(userProfile: nil))
     
     
        feedVC.tabBarItem.title = "Лента"
        feedVC.tabBarItem.image = UIImage(systemName: "house")
        
        searchVC.tabBarItem.title = "Поиск"
        searchVC.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        
        profileVC.tabBarItem.title = "Профиль"
        profileVC.tabBarItem.image = UIImage(systemName: "person")

        
        viewControllers = [feedVC, searchVC, profileVC]
    }
}
