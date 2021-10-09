//
//  NewsListBuilder.swift
//  News
//
//  Created by Gökhan KOCA on 8.10.2021.
//

import UIKit

final class NewsBuilder {
  
  static func make() -> NewsViewController {
    let storyboard = UIStoryboard(name: "News", bundle: nil)
    let viewController = storyboard.instantiateViewController(withIdentifier: "NewsViewController") as! NewsViewController
    viewController.viewModel = NewsViewModel()
    return viewController
  }
}
