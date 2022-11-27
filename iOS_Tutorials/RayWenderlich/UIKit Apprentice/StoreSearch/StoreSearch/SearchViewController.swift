  //
  //  ViewController.swift
  //  StoreSearch
  //
  //  Created by Fahim Farook on 01-08-2021.
  //

import UIKit

class SearchViewController: UIViewController {
  private var observer: Any!
  private var landscapeVC: LandscapeViewController?
  private let search = Search()
  weak var splitViewDetail: DetailViewController?
  
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    listenForBackgroundNotification()
    title = NSLocalizedString("Search", comment: "split view primary button")
    
    if UIDevice.current.userInterfaceIdiom != .pad {
      searchBar.becomeFirstResponder()
    }
    
    tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    var cellNib = UINib(nibName: K.searchCellID, bundle: nil)
    tableView.register(cellNib, forCellReuseIdentifier: K.searchCellID)
    cellNib = UINib(nibName: K.noResultsID, bundle: nil)
    tableView.register(cellNib, forCellReuseIdentifier: K.noResultsID)
    cellNib = UINib(nibName: K.loadingCellID, bundle: nil)
    tableView.register(cellNib, forCellReuseIdentifier: K.loadingCellID)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if UIDevice.current.userInterfaceIdiom == .phone {
      navigationController?.navigationBar.isHidden = true
    }
  }
  
  override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
    super.willTransition(to: newCollection, with: coordinator)
    
    switch newCollection.verticalSizeClass {
    case .compact:
      if newCollection.horizontalSizeClass == .compact {
        showLandscape(with: coordinator)
      }
    case .regular, .unspecified:
      hideLandscape(with: coordinator)
    @unknown default:
      break
    }
  }
  
  private func hidePrimaryPane() {
    UIView.animate(withDuration: 0.25, animations: {
      self.splitViewController!.preferredDisplayMode = .secondaryOnly
    }, completion: { _ in
      self.splitViewController!.preferredDisplayMode = .automatic
    })
  }
  
  func showLandscape(with coordinator: UIViewControllerTransitionCoordinator) {
    guard landscapeVC == nil else { return }
    landscapeVC = storyboard!.instantiateViewController(withIdentifier: K.landscapeVC) as? LandscapeViewController
    if self.presentedViewController != nil {
      self.dismiss(animated: true)
    }
    if let controller = landscapeVC {
      controller.search = search
      controller.view.frame = view.bounds
      controller.view.alpha = 0
      view.addSubview(controller.view)
      addChild(controller)
      coordinator.animate(alongsideTransition: { [unowned self] _ in
        controller.view.alpha = 1
        self.searchBar.resignFirstResponder()
      }, completion: { _ in
        controller.didMove(toParent: self)
      })
    }
  }
  
  func hideLandscape(with coordinator: UIViewControllerTransitionCoordinator) {
    if let controller = landscapeVC {
      controller.willMove(toParent: nil)
      coordinator.animate( alongsideTransition: { _ in
        controller.view.alpha = 0
        if self.presentedViewController != nil {
          self.dismiss(animated: true)
        }
      }, completion: { _ in
        controller.view.removeFromSuperview()
        controller.removeFromParent()
        self.landscapeVC = nil
      })
    }
  }
  
  
  @IBAction func segmentChanged(_ sender: UISegmentedControl) {
    performSearch()
  }
  
    // MARK: - Helper Methods
  
  
  func showNetworkError() {
    let alert = UIAlertController(
      title: NSLocalizedString("Whoops…", comment: "Whoops…"),
      message: NSLocalizedString("There was an error accessing the iTunes Store.", comment: "Error message displayed when network errors occur. Apologizes to user for interruption in results.") +
      NSLocalizedString(" Please try again", comment: "Request user to try their network request again."),
      preferredStyle: .alert)
    
    let action = UIAlertAction(
      title: NSLocalizedString("OK", comment: "OK"), style: .default, handler: nil)
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == K.showDetailSegue {
      if case .results(let list) = search.state {
        print("&&& SearchVC triggered segue to detail VC")
        let detailVC = segue.destination as! DetailViewController
        let indexPath = sender as! IndexPath
        detailVC.searchResult = list[indexPath.row]
        detailVC.isPopUp = true
      }
    }
  }
  
  func listenForBackgroundNotification() {
    observer = NotificationCenter.default.addObserver(
      forName: UIContentSizeCategory.didChangeNotification,
      object: nil,
      queue: OperationQueue.main) { [weak self] _ in
        guard let self = self else { return }
        self.tableView.reloadData()
      }
  }
}

  // MARK: - Search Bar Delegate
extension SearchViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    performSearch()
  }
  
  func performSearch() {
    if let category = Search.Category(rawValue: segmentedControl.selectedSegmentIndex) {
      search.performSearch(for: searchBar.text!, category: category) { success in
        if !success {
          self.showNetworkError()
        }
        self.tableView.reloadData()
        self.landscapeVC?.searchResultsReceived()
      }
      tableView.reloadData()
      searchBar.resignFirstResponder()
    }
  }
  
  func position(for bar: UIBarPositioning) -> UIBarPosition {
    return .topAttached
  }
}

  // MARK: - Table View Delegate
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView,numberOfRowsInSection section: Int) -> Int {
    switch search.state {
    case .notSearchedYet: return 0
    case .loading: return 1
    case .noResults: return 1
    case .results(let list):
      return list.count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch search.state {
    case .notSearchedYet: fatalError("Should never get here! FOOL OF A TOOK!")
    case .loading:
      let cell = tableView.dequeueReusableCell(withIdentifier: K.loadingCellID, for: indexPath)
      let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
      spinner.startAnimating()
      return cell
    case .noResults: return tableView.dequeueReusableCell(withIdentifier: K.noResultsID, for: indexPath)
    case .results(let list):
      let cell = tableView.dequeueReusableCell(withIdentifier: K.searchCellID, for: indexPath) as! SearchResultCell
      let searchResult = list[indexPath.row]
      cell.configure(for: searchResult)
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    searchBar.resignFirstResponder()
    
    if view.window!.rootViewController!.traitCollection.horizontalSizeClass == .compact {
      tableView.deselectRow(at: indexPath, animated: true)
      print("&&& segue from searchVC to detailVC")
      performSegue(withIdentifier: K.showDetailSegue, sender: indexPath)
    } else {
      if case .results(let list) = search.state {
        if splitViewController!.displayMode != .oneBesideSecondary { hidePrimaryPane() }
        
        splitViewDetail?.searchResult = list[indexPath.row]
      }
    }
  }
  
  func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    switch search.state {
    case .notSearchedYet, .loading, .noResults: return nil
    case .results: return indexPath
    }
    
  }
}
