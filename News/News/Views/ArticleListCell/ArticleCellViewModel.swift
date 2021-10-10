//
//  ArticleListCellViewModel.swift
//  News
//
//  Created by Gökhan KOCA on 9.10.2021.
//

import Foundation

struct ArticleListCellViewModel: Hashable {
  let id: UUID = UUID()
  let imageUrl: String?
  let title: String?
  let detail: String?
  let caption: Date?
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}
