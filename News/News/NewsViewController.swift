//
//  NewsViewController.swift
//  News
//
//  Created by Gökhan KOCA on 8.10.2021.
//

import UIKit

final class NewsViewController: UIViewController {
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  var viewModel: NewsViewModelProtocol? {
    didSet {
      viewModel?.delegate = self
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(CollectionViewItem.self)
    collectionView.register(ArticleListCell.self)
    collectionView.register(SectionHeader.self)
    viewModel?.load()
  }
  
  func showAlert(_ message: String) {
    let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { [weak self] _ in
      self?.viewModel?.load()
    }))
    present(alert, animated: true)
  }
}

extension NewsViewController: NewsViewModelDelegate {
  func handleViewModelOutput(_ output: NewsViewModelOutput) {
    switch output {
    case.error(let message):
      showAlert(message)
    case .updateTitle(let title):
      self.title = title
    case .newsDidLoad:
      collectionView.reloadData()
    }
  }
}

extension NewsViewController: UICollectionViewDelegate {
  
}

extension NewsViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    switch indexPath.section {
    case 0:
      return CGSize(width: UIScreen.main.bounds.width, height: 200)
    case 1:
      return CGSize(width: UIScreen.main.bounds.width - 32, height: 84)
    default:
      return CGSize()
    }
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    switch section {
    case 0:
      return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    case 1:
      return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    default:
      return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
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
  
}

extension NewsViewController: UICollectionViewDataSource {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    viewModel?.numberOfSections() ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    viewModel?.numberOfItemsIn(section: section) ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    switch indexPath.section {
    case 0:
      let cell = collectionView.dequeue(CollectionViewItem.self, indexPath: indexPath)
      cell.viewModel = viewModel?.latest()
      return cell
    case 1:
      let cell = collectionView.dequeue(ArticleListCell.self, indexPath: indexPath)
      cell.viewModel = viewModel?.article(at: indexPath.row)
      return cell
    default:
      return UICollectionViewCell()
    }
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      viewForSupplementaryElementOfKind kind: String,
                      at indexPath: IndexPath) -> UICollectionReusableView {
    let header = collectionView.dequeueHeader(SectionHeader.self, indexPath: indexPath)
    header.titleLabel.text = indexPath.section == 0 ? "Latest News" : "Articles"
    return header
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    CGSize(width: UIScreen.main.bounds.width, height: 48)
  }
}
