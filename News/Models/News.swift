//
//  News.swift
//  News
//
//  Created by Gökhan KOCA on 8.10.2021.
//

struct News: Decodable {
  let articles: [Article]?
  let status: String?
  let totalResults: Int?
}

