//
//  LoadableImageView.swift
//  News
//
//  Created by Gökhan KOCA on 9.10.2021.
//

import UIKit
import Combine

final class LoadableImageView: UIImageView {
  
  private var subscriber: AnyCancellable?
  private var activityIndicator: UIActivityIndicatorView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    activityIndicator = UIActivityIndicatorView(style: .medium)
    activityIndicator.color = .label
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    addSubview(activityIndicator)
    NSLayoutConstraint.activate([
      centerXAnchor.constraint(equalTo: activityIndicator.centerXAnchor),
      centerYAnchor.constraint(equalTo: activityIndicator.centerYAnchor)
    ])
    activityIndicator.hidesWhenStopped = true
  }
  
  func load(from urlString: String, contentMode: UIView.ContentMode = .scaleAspectFit, placeholder: String? = "placeholder") {
    activityIndicator.startAnimating()
    self.contentMode = contentMode
    if urlString.isEmpty {
      if let placeholder = placeholder {
        self.image = UIImage(named: placeholder)
        self.activityIndicator.stopAnimating()
        return
      }
      return
    }
    if let image = ImageRepository.shared.getImage(with: urlString.sha1Value) {
      self.image = image
      self.activityIndicator.stopAnimating()
      return
    }
    
    let url = URL(forceString: urlString)
    print("IMAGE -> downloading from \(url.absoluteString)")
    
    let request = URLRequest(url: url)
    subscriber = URLSession.DataTaskPublisher(request: request, session: .shared)
      .map { UIImage(data: $0.data) }
      .replaceError(with: nil)
      .sink(receiveValue: { image in
        guard let image = image else {
          if let placeholder = placeholder {
            DispatchQueue.main.async { [weak self] in
              print("IMAGE -> download failed. Returning placeholder")
              self?.activityIndicator.stopAnimating()
              self?.image = UIImage(named: placeholder)
            }
          }
          return
        }
        print("IMAGE -> download success. size: \(image.pngData()?.count ?? 0)")
        ImageRepository.shared.cache(image: image, with: urlString.sha1Value)
        DispatchQueue.main.async { [weak self] in
          self?.activityIndicator.stopAnimating()
          self?.image = image
        }
      })
  }
  
  func cancel() {
    subscriber?.cancel()
    activityIndicator.stopAnimating()
  }
}
