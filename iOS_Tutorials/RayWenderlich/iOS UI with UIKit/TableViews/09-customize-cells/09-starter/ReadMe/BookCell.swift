//
//  BookCell.swift
//  ReadMe
//
//  Created by Michael Brockman on 11/29/22.
//

import UIKit

class BookCell: UITableViewCell {
  static let reuseID = "BookCell"
  static let newBookReuseID = "NewBookCell"
  
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var authorLabel: UILabel!
  @IBOutlet var reviewLabel: UILabel!
  
  @IBOutlet var readMeBookmark: UIImageView!
  @IBOutlet var bookThumbnail: UIImageView!
  
}
