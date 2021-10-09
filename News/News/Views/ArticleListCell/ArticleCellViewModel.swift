//
//  ArticleListCellViewModel.swift
//  News
//
//  Created by Gökhan KOCA on 9.10.2021.
//

import Foundation

struct ArticleListCellViewModel: Hashable {
  let imageUrl: String?
  let title: String?
  let detail: String?
  let caption: Date?
}
