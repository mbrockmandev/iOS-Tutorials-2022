//
//  FavoritesListVC.swift
//  GHFollowers
//
//  Created by Michael Brockman on 11/19/22.
//

import UIKit

class FavoritesListVC: GFDataLoadingVC {
  
  let tableView = UITableView()
  var favorites: [Follower] = []
  
  //MARK: - View Lifecycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    configureVC()
    configureTableView()
    getFavorites()
  }
  
  //MARK: - Custom Methods
  func configureTableView() {
    view.addSubview(tableView)
    tableView.frame       = view.bounds
    tableView.rowHeight   = 80
    tableView.delegate    = self
    tableView.dataSource  = self
    
    tableView.removeExcessCells()
    tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseID)
  }
  
  func configureVC() {
    title = "Favorites"
    view.backgroundColor = .systemBackground
    navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  func getFavorites() {
    Task {
      do {
        let favorites = try await PersistenceManager.retrieveFavorites()
        updateUI(with: favorites)
      } catch {
        if let gfError = error as? GFError {
          presentGFAlert(title: "Unable to add favorite", message: gfError.rawValue, buttonTitle: "OK")
        }
      }
    }
  }
  
  func updateUI(with favorites: [Follower]) {
    if favorites.isEmpty {
      self.showEmptyStateView(with: "No Favorites?\nAdd one on the follower screen.", in: self.view)
    } else {
      self.favorites = favorites
      DispatchQueue.main.async {
        self.tableView.reloadData()
        self.view.bringSubviewToFront(self.tableView)
      }
    }
  }
  
}

extension FavoritesListVC: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return favorites.count
  }
    
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  
    let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseID) as! FavoriteCell
    let favorite = self.favorites[indexPath.row]
    cell.set(favorite: favorite)
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let favorite = favorites[indexPath.row]
    let destVC = FollowerListVC(username: favorite.login)
    navigationController?.pushViewController(destVC, animated: true)
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    guard editingStyle == .delete else { return }
    let favorite = favorites[indexPath.row]
    
    Task {
      do {
        try await PersistenceManager.updateWith(favorite: favorite, actionType: .remove)
        self.favorites.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
      } catch {
        if let gfError = error as? GFError {
          presentGFAlert(title: "Unable to add favorite", message: gfError.rawValue, buttonTitle: "OK")
        }
      }
    }
  }
}
