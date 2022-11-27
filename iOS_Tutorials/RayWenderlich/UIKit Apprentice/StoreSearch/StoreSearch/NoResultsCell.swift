//
//  NoResultsCell.swift
//  StoreSearch
//
//  Created by Michael Brockman on 9/25/22.
//

import UIKit

class NoResultsCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      let selectedView = UIView(frame: CGRect.zero)
      selectedView.backgroundColor = UIColor(named: "SearchBar")?.withAlphaComponent(0.5)
      selectedBackgroundView = selectedView
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
