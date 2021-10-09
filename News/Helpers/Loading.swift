//
//  Loading.swift
//  News
//
//  Created by Gökhan KOCA on 8.10.2021.
//

import UIKit

class Loading {
  
  private class LoadingView: UIView {}
  
  class func show() {
    guard
      let view = UIApplication.shared.windows.first,
      !(view.subviews.contains(where: { $0.isKind(of: LoadingView.self) }))
    else { return }
    
    let backgroundView = LoadingView()
    backgroundView.frame = UIScreen.main.bounds
    backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
    let activityIndicator = UIActivityIndicatorView(style: .large)
    activityIndicator.color = .white
    backgroundView.addSubview(activityIndicator)
    activityIndicator.center = backgroundView.center
    
    view.addSubview(backgroundView)
    activityIndicator.startAnimating()
  }
  
  class func hide() {
    DispatchQueue.main.async {
      UIApplication
        .shared
        .windows
        .first?
        .subviews
        .first(where: { $0.isKind(of: LoadingView.self) })?
        .removeFromSuperview()
    }
  }
}
