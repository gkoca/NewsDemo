//
//  NewsApi.swift
//  News
//
//  Created by Gökhan KOCA on 8.10.2021.
//

import Foundation

enum NewsApi: Caller {
  
  case news
  
  var baseURL: URL {
    let baseURLString = Bundle.main.infoForKey("baseURL") ?? ""
    return URL(forceString: baseURLString)
  }
  
  var path: String {
    "/everything/cnn.json"
  }
  
  var method: HTTPMethod {
    .get
  }
}
