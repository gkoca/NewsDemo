//
//  LatestArticleCell.swift
//  News
//
//  Created by Gökhan KOCA on 9.10.2021.
//

import UIKit

final class LatestArticleCell: UICollectionViewCell {
  
  var viewModel: ArticleListCellViewModel? {
    didSet {
      setViewModel()
    }
  }
  
  @IBOutlet weak var imageView: LoadableImageView!
  @IBOutlet weak var titleLabel: UILabel!
  
  func setViewModel() {
    imageView.load(from: viewModel?.imageUrl ?? "", contentMode: .scaleAspectFill)
    imageView.layer.cornerRadius = 16
    titleLabel.text = viewModel?.title
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    imageView.cancel()
    imageView.image = nil
  }
}
