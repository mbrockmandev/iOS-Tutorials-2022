//
//  DataSource.swift
//  EmojiLibrary
//
//  Created by Michael Brockman on 12/1/22.
//

import UIKit

class DataSource: NSObject, UICollectionViewDataSource {
  let emoji = Emoji.shared

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    emoji.sections.count
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    let category = emoji.sections[section]
    let emoji = self.emoji.data[category]?.count ?? 0
    return emoji
  }
  
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCell.reuseIdentifier, for: indexPath) as? EmojiCell else { fatalError("Could not dequeue cell as EmojiCell.") }
    let category = emoji.sections[indexPath.section]
    let emoji = self.emoji.data[category]?[indexPath.item] ?? ""
    
    cell.emojiLabel.text = emoji
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    guard let emojiHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: EmojiHeaderView.reuseID, for: indexPath) as? EmojiHeaderView else { fatalError("Unable to create emoji header view") }
    
    let category = emoji.sections[indexPath.section]
    emojiHeaderView.textLabel.text = category.rawValue
    
    return emojiHeaderView
    
  }
  
}

extension DataSource {
  func addEmoji(_ emoji: String, to category: Emoji.Category) {
    guard var emojiData = self.emoji.data[category] else { return }
    emojiData.append(emoji)
    self.emoji.data.updateValue(emojiData, forKey: category)
  }
  
  func deleteEmoji(at indexPath: IndexPath) {
    let category = emoji.sections[indexPath.section]
    guard var emojiData = emoji.data[category] else { return }
    emojiData.remove(at: indexPath.item)
    emoji.data.updateValue(emojiData, forKey: category)
  }
  
  func deleteEmoji(at indexPaths: [IndexPath]) {
    for path in indexPaths {
      deleteEmoji(at: path)
    }
  }
}
