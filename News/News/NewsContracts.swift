//
//  NewsContracts.swift
//  News
//
//  Created by Gökhan KOCA on 8.10.2021.
//

import Foundation

protocol NewsViewModelProtocol {
  var delegate: NewsViewModelDelegate? { get set }
  func load()
  func getArticles() -> [ArticleListCellViewModel]
  func getLatest() -> [ArticleListCellViewModel]
}

enum NewsViewModelOutput {  
  case updateTitle(String)
  case newsDidLoad
  case error(message: String)
}

enum MovieListViewRoute {
  //    case detail(Article)
}

protocol NewsViewModelDelegate: AnyObject {
  func handleViewModelOutput(_ output: NewsViewModelOutput)
}

