//
//  ImageRepository.swift
//  News
//
//  Created by Gökhan KOCA on 8.10.2021.
//

import UIKit

class ImageRepository {

  static let shared = ImageRepository()

  private var imageCache = NSCache<AnyObject, UIImage>()

  func cache(image: UIImage, with id: String) {
    imageCache.setObject(image, forKey: id as AnyObject)
    let cacheURL = getCacheDirectoryPath()
    if let data = image.jpegData(compressionQuality: 1) {
      let fileName = id.replacingOccurrences(of: "/", with: "")
      let fileURL = cacheURL.appendingPathComponent(String(fileName))
      try? data.write(to: fileURL, options: .atomic)
    }
  }

  func getImage(with id: String) -> UIImage? {
    if let image = imageCache.object(forKey: id as AnyObject) {
      return image
    }
    let cacheURL = getCacheDirectoryPath()
    let fileName = id.replacingOccurrences(of: "/", with: "")
    let fileURL = cacheURL.appendingPathComponent(fileName)
    do {
      let imageData = try Data(contentsOf: fileURL)
      if let image = UIImage(data: imageData) {
        imageCache.setObject(image, forKey: id as AnyObject)
        return image
      }
    } catch {
      print("IMAGE -> Reading from file failed with error: \(error.localizedDescription)")
    }
    return nil
  }

  private func getCacheDirectoryPath() -> URL {
    let arrayPaths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
    let cacheDirectoryPath = arrayPaths[0]
    return cacheDirectoryPath
  }
}
