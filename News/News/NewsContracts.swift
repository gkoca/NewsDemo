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
  func getTitle() -> String
  func numberOfSections() -> Int
  func numberOfItemsIn(section: Int) -> Int
  func article(at index: Int) -> ArticleListCellViewModel
  func latest() -> CollectionViewItemViewModel
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

