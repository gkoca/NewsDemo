//
//  Article.swift
//  News
//
//  Created by Gökhan KOCA on 8.10.2021.
//

import Foundation

struct Article: Decodable {
  let author: String?
  let content: String?
  let descriptionField: String?
  let publishedAt: Date?
  let source: Source?
  let title: String?
  let url: String?
  let urlToImage: String?
}
