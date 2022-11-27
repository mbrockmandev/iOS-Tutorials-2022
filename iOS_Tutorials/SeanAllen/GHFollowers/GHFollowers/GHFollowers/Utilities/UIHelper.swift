//
//  UIHelper.swift
//  GHFollowers
//
//  Created by Michael Brockman on 11/21/22.
//

import UIKit

enum UIHelper {
  
  static func createThreeColumnFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
    let width = view.bounds.width
    let padding: CGFloat = 12
    let minimumItemSpacing: CGFloat = 10
    let availableWidth = width - (padding * 2) - (minimumItemSpacing * 2)
    let itemWidth = availableWidth / 3
    
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.sectionInset = UIEdgeInsets(top: 32, left: padding, bottom: padding, right: padding)
    flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + (itemWidth * 0.2)) //change the height modifier if needed to fit label -- he used 40
    
    return flowLayout
  }
}
