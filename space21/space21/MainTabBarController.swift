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
        let profileVC = UINavigationController(rootViewController: ProfileViewController(userProfile: UserProfile(nickname: "TEST", avatar: "https://storage.yandexcloud.net/space21/avatars/default/logo-discord.jpeg", name: nil, surname: nil, birthdate: nil, phone: nil, city: nil, telegram: nil, git: nil, os: nil, work: nil, university: nil, skills: nil, hobbies: nil)))
        
     
     
        feedVC.tabBarItem.title = "Лента"
        feedVC.tabBarItem.image = UIImage(systemName: "house")
        
        searchVC.tabBarItem.title = "Поиск"
        searchVC.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        
        profileVC.tabBarItem.title = "Профиль"
        profileVC.tabBarItem.image = UIImage(systemName: "person")

        
        viewControllers = [feedVC, searchVC, profileVC]
    }
}
