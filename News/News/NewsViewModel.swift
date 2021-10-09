//
//  NewsViewModel.swift
//  News
//
//  Created by Gökhan KOCA on 8.10.2021.
//

import Foundation
import Combine

final class NewsViewModel: NewsViewModelProtocol {
  
  var delegate: NewsViewModelDelegate?
  private var subscriber: AnyCancellable?
  var news: News? {
    didSet {
      configureArticles()
    }
  }
  var latestArticles: [Article] = []
  var articles: [Article] = []
  
  func load() {
    subscriber?.cancel()
    delegate?.handleViewModelOutput(.updateTitle("News"))
    
    subscriber = NewsApi.news.call(News.self, shoudShowLoading: true)
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { [weak self] in
        print($0)
        switch $0 {
        case .finished:
          break
        case .failure(let error):
          self?.delegate?.handleViewModelOutput(.error(message: error.localizedDescription))
        }
      }, receiveValue: { [weak self] in
        self?.news = $0
        self?.delegate?.handleViewModelOutput(.newsDidLoad)
      })
  }
  
  private func configureArticles() {
    var allArticles = news?.articles?.sorted {
      guard let lhsDate = $0.publishedAt, let rhsDate = $1.publishedAt
      else { return false }
      return lhsDate > rhsDate
    } ?? []
    latestArticles = Array<Article>(allArticles.prefix(6))
    allArticles.removeFirst(6)
    articles = allArticles
  }
  
  func getTitle() -> String {
    "News"
  }
  
  func numberOfSections() -> Int {
    news != nil ? 2 : 0
  }
  
  func numberOfItemsIn(section: Int) -> Int {
    switch section {
    case 0:
      return 1
    case 1:
      return articles.count
    default:
      return 0
    }
  }
  
  func article(at index: Int) -> ArticleListCellViewModel {
    let article = articles[index]
    return ArticleListCellViewModel(imageUrl: article.urlToImage,
                                    title: article.title,
                                    detail: article.content,
                                    caption: article.publishedAt)
  }
  
  func latest() -> CollectionViewItemViewModel {
    CollectionViewItemViewModel(items: latestArticles.map { article in
      LatestArticleCellViewModel(imageUrl: article.urlToImage,
                                 title: article.title,
                                 detail: article.content)
    })
  }
}
