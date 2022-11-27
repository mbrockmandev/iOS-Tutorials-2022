//
//  FollowerListVC.swift
//  GHFollowers
//
//  Created by Michael Brockman on 11/19/22.
//

import UIKit

class FollowerListVC: GFDataLoadingVC {
  
  enum Section {
    case main
  }
  
  var username: String!
  var followers: [Follower] = []
  var filteredFollowers: [Follower] = []
  var page = 1
  var hasMoreFollowers = true
  var isSearching = false
  var isLoadingMoreFollowers = false
  
  var collectionView: UICollectionView!
  var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
  
  init(username: String) {
    super.init(nibName: nil, bundle: nil)
    self.username = username
    title = username
  }
  
  required init?(coder: NSCoder) { fatalError("NO STORYBOARD INIT") }
  
  //MARK: - View LifeCycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    configureViewController()

    getFollowers(username: username, page: page)
    configureCollectionView()
    configureDiffDataSource()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(false, animated: true)
  }
  
  //MARK: - Custom Methods
  override func viewDidLayoutSubviews() {
    configureSearchController()
  }
  
  func configureViewController() {
    view.backgroundColor = .systemBackground
    navigationController?.navigationBar.prefersLargeTitles = true
    
    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
    navigationItem.rightBarButtonItem = addButton
  }
  
  func configureCollectionView() {
    //UICollectionViewLayout can be replaced with custom layout
    collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
    view.addSubview(collectionView)
    collectionView.delegate = self
    collectionView.backgroundColor = .systemBackground
    collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
  }
  
  func configureDiffDataSource() {
    dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, follower in
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
      cell.set(follower: follower)
      return cell
    })
  }
  
  func configureSearchController() {
    let searchController = UISearchController()
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search for a user"
    searchController.hidesNavigationBarDuringPresentation = false
    navigationItem.searchController = searchController
  }
  
  //MARK: - Networking Calls
  func getFollowers(username: String, page: Int) {
    showLoadingView()
    isLoadingMoreFollowers = true
    
    //old network call
//    NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
//      guard let self else { return }
//      self.dismissLoadingView()
//
//      switch result {
//      case .success(let followers):
//        self.updateUI(with: followers)
//
//      case .failure(let failure):
//        self.presentGFAlertOnMainThread(title: "Oh NO!", message: failure.rawValue, buttonTitle: "OK")
//      }
//    }
    
    //Task allows for async code without labeling function as async
    Task {
      do {
        let followers = try await NetworkManager.shared.getFollowers(for: username, page: page)
        updateUI(with: followers)
        dismissLoadingView()
      } catch {
        if let gfError = error as? GFError {
          presentGFAlert(title: "Oh NO!", message: gfError.rawValue, buttonTitle: "OK")
        } else {
          presentDefaultError()
        }
        dismissLoadingView()
      }
    }
    
    //another way to handle async code call
//    Task {
//      guard let followers = try? await NetworkManager.shared.getFollowers(for: username, page: page) else {
//        presentDefaultGFErrorAlert()
//        dismissLoadingView()
//        return
//      }
//
//      updateUI(with: followers)
//      dismissLoadingView()
//    }
  }
  
  func updateUI(with followers: [Follower]) {
    if followers.count < 100 { self.hasMoreFollowers = false }
    self.followers.append(contentsOf: followers)
    
    if self.followers.isEmpty {
      let message = "This user doesn't have any followers. Please follow them! 😇"
      DispatchQueue.main.async {
        self.showEmptyStateView(with: message, in: self.view)
        return
      }
    }
    
    self.updateData(on: self.followers)
  }
  
  func updateData(on followers: [Follower]) {
    var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
    snapshot.appendSections([.main])
    snapshot.appendItems(followers)
    DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
  }
  
  @objc func addButtonTapped() {
    showLoadingView()
    isLoadingMoreFollowers = true
    
    Task {
      do {
        let user = try await NetworkManager.shared.getUserInfo(for: username)
        addUserToFavorites(user)
        dismissLoadingView()
      } catch {
        if let gfError = error as? GFError {
          presentGFAlert(title: "Something weng wrong!", message: gfError.rawValue, buttonTitle: "OK")
        } else {
          presentDefaultError()
        }
        dismissLoadingView()
      }
    }
    isLoadingMoreFollowers = false
  }
  
  func addUserToFavorites(_ user: User) {
    let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
    
    Task {
      do {
        try await PersistenceManager.updateWith(favorite: favorite, actionType: .add)
        presentGFAlert(title: "Success", message: "Successfully added user to favorites 😃", buttonTitle: "OK")
      } catch {
        if let gfError = error as? GFError {
          presentGFAlert(title: "Unable to add favorite", message: gfError.rawValue, buttonTitle: "OK")
        }
      }
    }
  }
  
}

extension FollowerListVC: UICollectionViewDelegate {
  
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    let offsetY           = scrollView.contentOffset.y
    let contentHeight     = scrollView.contentSize.height
    let scrollViewHeight  = scrollView.frame.size.height
    
    if offsetY > contentHeight - scrollViewHeight {
      guard !isLoadingMoreFollowers, hasMoreFollowers else { return }
      page += 1
      getFollowers(username: username, page: page)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let userInfoVC      = UserInfoVC()
    let follower        = isSearching ? filteredFollowers[indexPath.item] : followers[indexPath.item]
    userInfoVC.username = follower.login
    userInfoVC.delegate = self
    let navController = UINavigationController(rootViewController: userInfoVC)
    present(navController, animated: true)
  }
  
}

extension FollowerListVC: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    guard let filter = searchController.searchBar.text, !filter.isEmpty else {
      filteredFollowers.removeAll()
      updateData(on: followers)
      return
    }
    filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
    updateData(on: filteredFollowers)
    isSearching = true
  }

}

extension FollowerListVC: UserInfoVCDelegate {
  func didRequestFollowers(for username: String) {
    self.username = username
    title         = username
    page          = 1
    
    followers.removeAll()
    filteredFollowers.removeAll()
    getFollowers(username: username, page: page)
    collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
  }
}
