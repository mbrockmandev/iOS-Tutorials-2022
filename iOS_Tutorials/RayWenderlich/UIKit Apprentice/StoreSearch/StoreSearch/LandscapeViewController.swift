  //
  //  LandscapeViewController.swift
  //  StoreSearch
  //
  //  Created by Michael Brockman on 9/30/22.
  //

import UIKit

class LandscapeViewController: UIViewController {
  private var firstTime = true
  private var downloads = [URLSessionDownloadTask]()
  var search: Search!
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var pageControl: UIPageControl!
  
  @IBAction func pageChanged(_ sender: UIPageControl) {
    
    UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut], animations: {
      self.scrollView.contentOffset = CGPoint(x: self.scrollView.bounds.size.width * CGFloat(sender.currentPage), y: 0)
    })
    scrollView.contentOffset = CGPoint(
      x: scrollView.bounds.size.width * CGFloat(sender.currentPage),
      y: 0)
  }
  
  @objc private func buttonPressed(_ sender: UIButton) {
    performSegue(withIdentifier: K.showDetailSegue, sender: sender)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == K.showDetailSegue {
      if case .results(let list) = search.state {
        print("&&& LandscapeVC triggered segue to detail VC")
        let detailVC = segue.destination as! DetailViewController
        let searchResult = list[(sender as! UIButton).tag - 2000]
        detailVC.searchResult = searchResult
        detailVC.isPopUp = true
      }
    }
  }
  
  deinit {
    for task in downloads {
      task.cancel()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    
  }
  
  func configureUI() {
    view.backgroundColor = UIColor(patternImage: UIImage(named: K.landscapeBackground)!)
    view.removeConstraints(view.constraints)
    view.translatesAutoresizingMaskIntoConstraints = true
    
    pageControl.removeConstraints(pageControl.constraints)
    pageControl.translatesAutoresizingMaskIntoConstraints = true
    pageControl.numberOfPages = 0
    
    scrollView.removeConstraints(scrollView.constraints)
    scrollView.translatesAutoresizingMaskIntoConstraints = true
    
    
  }
  
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    let safeFrame = view.safeAreaLayoutGuide.layoutFrame
    scrollView.frame = safeFrame
    pageControl.frame = CGRect(x: safeFrame.origin.x, y: safeFrame.size.height - pageControl.frame.size.height, width: safeFrame.size.width, height: pageControl.frame.size.height)
    switch search.state {
    case .notSearchedYet: break
    case .loading: showSpinner()
    case .noResults: showNothingFoundLabel()
    case .results(let list): tileButtons(list)
    }
  }
  
  
  private func tileButtons(_ searchResults: [SearchResult]) {
    let itemWidth: CGFloat = 94
    let itemHeight: CGFloat = 88
    var columnsPerPage = 0
    var rowsPerPage = 0
    var marginX: CGFloat = 0
    var marginY: CGFloat = 0
    let tmpViewWidth = view.window?.windowScene?.screen.bounds.size.width
    let tmpViewHeight = view.window?.windowScene?.screen.bounds.size.height
    guard let viewWidth = tmpViewWidth, let viewHeight = tmpViewHeight else { return }
    
    
    columnsPerPage = Int(viewWidth / itemWidth)
    rowsPerPage = Int(viewHeight / itemHeight)
    
    marginX = (viewWidth - (CGFloat(columnsPerPage) * itemWidth)) * 0.5
    marginY = (viewHeight - (CGFloat(rowsPerPage) * itemHeight)) * 0.5
    
    let buttonWidth: CGFloat = 82
    let buttonHeight: CGFloat = 82
    let paddingHorz = (itemWidth - buttonWidth) / 2
    let paddingVert = (itemHeight - buttonHeight) / 2
    
    var row = 0
    var column = 0
    var x = marginX
    for (index, result) in searchResults.enumerated() {
      let button = UIButton(type: .custom)
      button.setBackgroundImage(UIImage(named: K.landscapeButton), for: .normal)
      button.backgroundColor = UIColor.systemBackground
      button.tag = 2000 + index
      button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
      downloadImage(for: result, andPlaceOn: button)
      button.frame = CGRect(x: x + paddingHorz, y: marginY + CGFloat(row) * itemHeight + paddingVert, width: buttonWidth, height: buttonHeight)
      scrollView.addSubview(button)
      row += 1
      if row == rowsPerPage {
        row = 0; x += itemWidth; column += 1
        if column == columnsPerPage {
          column = 0; x += marginX * 2
        }
      }
    }
    
    let buttonsPerPage = columnsPerPage * rowsPerPage
    let numPages = 1 + (searchResults.count - 1) / buttonsPerPage
    scrollView.contentSize = CGSize(
      width: CGFloat(numPages) * viewWidth,
      height: scrollView.bounds.size.height)
    pageControl.numberOfPages = numPages
    pageControl.currentPage = 0
  }
  
  private func showSpinner() {
    let spinner = UIActivityIndicatorView(style: .large)
    spinner.center = CGPoint(x: scrollView.bounds.midX + 0.5, y: scrollView.bounds.midY + 0.5)
    spinner.tag = 1000
    view.addSubview(spinner)
    spinner.startAnimating()
  }
  
  private func hideSpinner() {
    view.viewWithTag(1000)?.removeFromSuperview()
  }
  
  private func downloadImage(for searchResult: SearchResult, andPlaceOn button: UIButton) {
    if let url = URL(string: searchResult.imageSmall) {
      let task = URLSession.shared.downloadTask(with: url) {
        [weak button] url, _, error in
        if error == nil, let url = url,
           let data = try? Data(contentsOf: url),
           let image = UIImage(data: data) {
          DispatchQueue.main.async {
            if let button = button {
              button.setImage(image, for: .normal)
            }
          }
        }
      }
      task.resume()
      downloads.append(task)
    }
  }
  
  func searchResultsReceived() {
    hideSpinner()
    
    switch search.state {
    case .notSearchedYet, .loading: break
    case .noResults: showNothingFoundLabel()
    case .results(let list): tileButtons(list)
    }
  }
  
  private func showNothingFoundLabel() {
    let label = UILabel(frame: .zero)
    label.text = NSLocalizedString("Nothing Found", comment: "Nothing Found")
    label.textColor = .label
    label.backgroundColor = .clear
    label.sizeToFit()
    
    var rect = label.frame
    rect.size.width = ceil(rect.size.width / 2) * 2
    rect.size.height = ceil(rect.size.height / 2) * 2
    
    label.center = CGPoint(x: scrollView.bounds.midX, y: scrollView.bounds.midY)
    view.addSubview(label)
  }
  
  
}

extension LandscapeViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let width = scrollView.bounds.size.width
    let page = Int((scrollView.contentOffset.x + width / 2) / width)
    pageControl.currentPage = page
  }
}
