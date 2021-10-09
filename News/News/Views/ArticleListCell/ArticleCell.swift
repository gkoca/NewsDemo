//
//  ArticleCell.swift
//  News
//
//  Created by Gökhan KOCA on 9.10.2021.
//

import UIKit

final class ArticleCell: UICollectionViewCell {
  
  var viewModel: ArticleListCellViewModel? {
    didSet {
      setViewModel()
    }
  }
  
  @IBOutlet weak var imageView: LoadableImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var detailLabel: UILabel!
  @IBOutlet weak var captionLabel: UILabel!
  
  func setViewModel() {
    imageView.load(from: viewModel?.imageUrl ?? "",contentMode: .scaleAspectFill)
    imageView.layer.cornerRadius = 8
    titleLabel.text = viewModel?.title
    detailLabel.text = viewModel?.detail
    if let date = viewModel?.caption {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
      captionLabel.text = dateFormatter.string(from: date)
    }
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    imageView.cancel()
    imageView.image = nil
  }
}
