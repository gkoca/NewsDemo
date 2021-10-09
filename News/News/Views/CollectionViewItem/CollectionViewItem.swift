//
//  CollectionViewItem.swift
//  News
//
//  Created by Gökhan KOCA on 9.10.2021.
//

import UIKit

final class CollectionViewItem: UICollectionViewCell {
  
  var viewModel: CollectionViewItemViewModel? {
    didSet {
      setViewModel()
    }
  }
  @IBOutlet weak var collectionView: UICollectionView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    collectionView.register(LatestArticleCell.self)
  }
  
  func setViewModel() {
    collectionView.reloadData()
  }
}

extension CollectionViewItem: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    viewModel?.items.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeue(LatestArticleCell.self, indexPath: indexPath)
    cell.viewModel = viewModel?.items[indexPath.row]
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
      0
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      8
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    
      UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)

  }
  
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    CGSize(width: collectionView.frame.size.width - 48, height: collectionView.frame.size.height)
  }
}
