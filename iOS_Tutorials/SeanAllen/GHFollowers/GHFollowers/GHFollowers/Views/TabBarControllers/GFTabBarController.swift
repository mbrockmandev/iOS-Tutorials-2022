//
//  GFTabBarController.swift
//  GHFollowers
//
//  Created by Michael Brockman on 11/25/22.
//

import UIKit

class GFTabBarController: UITabBarController {

  override func viewDidLoad() {
    super.viewDidLoad()
    UITabBar.appearance().tintColor = .systemGreen
    viewControllers = [createSearchNC(), createFavoritesNC()]
  }

  func createSearchNC() -> UINavigationController {
    let searchVC = SearchVC()
    searchVC.title = "Search"
    searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
    
    return UINavigationController(rootViewController: searchVC)
  }
  
  func createFavoritesNC() -> UINavigationController {
    let favoritesListVC = FavoritesListVC()
    favoritesListVC.title = "Search"
    favoritesListVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
    
    return UINavigationController(rootViewController: favoritesListVC)
  }
  
}
