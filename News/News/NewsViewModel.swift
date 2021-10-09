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
  
  func getArticles() -> [ArticleListCellViewModel] {
    articles.map { article in
      ArticleListCellViewModel(imageUrl: article.urlToImage,
                                      title: article.title,
                                      detail: article.content,
                                      caption: article.publishedAt)
    }
  }
  
  func getLatest() -> [ArticleListCellViewModel] {
    latestArticles.map { article in
      ArticleListCellViewModel(imageUrl: article.urlToImage,
                                      title: article.title,
                                      detail: article.content,
                                      caption: article.publishedAt)
    }
  }
}
