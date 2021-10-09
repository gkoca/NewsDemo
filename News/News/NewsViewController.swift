//
//  NewsViewController.swift
//  News
//
//  Created by Gökhan KOCA on 8.10.2021.
//

import UIKit

final class NewsViewController: UIViewController, UICollectionViewDelegate {
  
  enum Section: Int {
    case latest = 0
    case list
  }
  
  var viewModel: NewsViewModelProtocol? {
    didSet {
      viewModel?.delegate = self
    }
  }
  
  var dataSource: UICollectionViewDiffableDataSource<Section, ArticleListCellViewModel>! = nil
  var collectionView: UICollectionView! = nil
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureCollectionView()
    viewModel?.load()
  }
  
  func showAlert(_ message: String) {
    let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { [weak self] _ in
      self?.viewModel?.load()
    }))
    present(alert, animated: true)
  }
  
  private func configureCollectionView() {
    collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
    collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    collectionView.backgroundColor = .systemBackground
    collectionView.register(ArticleCell.self)
    collectionView.register(LatestArticleCell.self)
    collectionView.register(SectionHeader.self)
    collectionView.delegate = self
    view.addSubview(collectionView)
  }
  
  
  private func listSection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 8, trailing: 16)
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(96))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                          heightDimension: .absolute(44))
    let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                             elementKind: UICollectionView.elementKindSectionHeader,
                                                             alignment: .top)
    let section = NSCollectionLayoutSection(group: group)
    section.boundarySupplementaryItems = [header]
    return section
  }
  
  private func gridSection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(1.0))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 8, trailing: 16)
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.3))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .groupPaging
    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                          heightDimension: .absolute(44))
    let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                             elementKind: UICollectionView.elementKindSectionHeader,
                                                             alignment: .top)
    section.boundarySupplementaryItems = [header]
    return section
  }
  
  private func createLayout() -> UICollectionViewLayout {
    let layout = UICollectionViewCompositionalLayout { sectionNumber, env -> NSCollectionLayoutSection? in
      switch Section(rawValue: sectionNumber) {
      case .latest:
        return self.gridSection()
      case .list:
        return self.listSection()
      default:
        return nil
      }
    }
    layout.configuration.interSectionSpacing = 16
    return layout
  }
  
  private func renderData() {
    dataSource = UICollectionViewDiffableDataSource<Section, ArticleListCellViewModel>(collectionView: collectionView) {
      (collectionView: UICollectionView, indexPath: IndexPath, identifier: ArticleListCellViewModel) -> UICollectionViewCell? in
      
      switch indexPath.section {
      case 0:
        let cell = collectionView.dequeue(LatestArticleCell.self, indexPath: indexPath)
        cell.viewModel = identifier
        return cell
      case 1:
        let cell = collectionView.dequeue(ArticleCell.self, indexPath: indexPath)
        cell.viewModel = identifier
        return cell
      default:
        return UICollectionViewCell()
      }
    }
    
    dataSource.supplementaryViewProvider = {(
      collectionView: UICollectionView,
                  kind: String,
                  indexPath: IndexPath) -> UICollectionReusableView? in
      let header = collectionView.dequeueHeader(SectionHeader.self, indexPath: indexPath)
      header.titleLabel.text = indexPath.section == 0 ? "Latest News" : "Articles"
      return header
    }
    
    var snapshot = NSDiffableDataSourceSnapshot<Section, ArticleListCellViewModel>()
    snapshot.appendSections([.latest, .list])
    snapshot.appendItems(viewModel?.getLatest() ?? [], toSection: .latest)
    snapshot.appendItems(viewModel?.getArticles() ?? [], toSection: .list)
    dataSource.apply(snapshot, animatingDifferences: false)
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
      renderData()
    }
  }
}
