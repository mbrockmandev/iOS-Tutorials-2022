/// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit



class LibraryViewController: UITableViewController {

  
  @IBSegueAction func showDetailView(_ coder: NSCoder) -> DetailViewController? {
    guard let indexPath = tableView.indexPathForSelectedRow
      else { fatalError("Nothing selected!") }
    let book = Library.books[indexPath.row]
    return DetailViewController(coder: coder, book: book)
  }
  
  @IBSegueAction func showNewBookView(_ coder: NSCoder) -> NewBookVC? {
    guard tableView.indexPathForSelectedRow != nil else { fatalError("Nothing selected!") }
    return NewBookVC(coder: coder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    addTableViewHeaderSectionOne()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
  }
  
  func addTableViewHeaderSectionOne() {
    tableView.register(LibraryHeaderView.self, forHeaderFooterViewReuseIdentifier: LibraryHeaderView.reuseID)
  }
  
  //MARK: - Delegate
//  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//    return section != 0 ? "Read Me!" : nil
//  }

  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if section == 0 { return nil }
    let headerView = tableView.dequeueReusableHeaderFooterView(
      withIdentifier: LibraryHeaderView.reuseID) as! LibraryHeaderView
    
    headerView.backgroundImageView.image = UIImage(named: "BookTexture")
    headerView.titleLabel.text = "Read Me!"
    
    return headerView
  }

  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return section == 0 ? 0 : 60
  }
  
  // MARK:- Data Source
  override func numberOfSections(in tableView: UITableView) -> Int {
    2
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return section == 0 ? 1 : Library.books.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath == IndexPath(row: 0, section: 0) {
      let cell = tableView.dequeueReusableCell(withIdentifier: "NewBookCell", for: indexPath)
      return cell
    }
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(BookCell.self)", for: indexPath) as? BookCell
    else { fatalError("Could not create BookCell") }
    let book = Library.books[indexPath.row]
    cell.titleLabel.text = book.title
    cell.authorLabel.text = book.author
    cell.bookThumbnail.image = book.image
    cell.bookThumbnail.layer.cornerRadius = 12
    return cell
  }
}

