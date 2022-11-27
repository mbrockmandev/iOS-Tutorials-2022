import UIKit

class SearchResultCell: UITableViewCell {
  var downloadTask: URLSessionDownloadTask?
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var artistNameLabel: UILabel!
  @IBOutlet weak var artworkImageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
      // New code below
    let selectedView = UIView(frame: CGRect.zero)
    selectedView.backgroundColor = UIColor(named: K.searchBar)?.withAlphaComponent(0.5)
    selectedBackgroundView = selectedView
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
      // Configure the view for the selected state
  }
  
  func configure(for result: SearchResult) {
    nameLabel.text = result.name
    
    if result.artist.isEmpty {
      artistNameLabel.text = NSLocalizedString("Unknown", comment: "Unknown")
    } else {
      artistNameLabel.text = String(
        format: NSLocalizedString("artistNameLabelForSearchResultCell", comment: "Format for artist name"),
        result.artist,
        result.type)
    }
    
    artworkImageView.image = UIImage(systemName: "square")
    if let smallURL = URL(string: result.imageSmall) {
      downloadTask = artworkImageView.loadImage(url: smallURL)
    }
  }
}
