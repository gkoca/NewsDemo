//
//  Extensions.swift
//  News
//
//  Created by Gökhan KOCA on 8.10.2021.
//

import Foundation
import UIKit
import Combine
import CommonCrypto

extension Bundle {
  func infoForKey(_ key: String) -> String? {
    guard let configs = infoDictionary?["Configs"] as? [String: String] else { return nil }
    return (configs[key])?.replacingOccurrences(of: "\\", with: "")
  }
}

extension URL {
  init(forceString string: String) {
    guard let url = URL(string: string) else { fatalError("Could not init URL '\(string)'") }
    self = url
  }
}


extension String {
  var sha1Value: String {
    let length = Int(CC_SHA1_DIGEST_LENGTH)
    var digest = [UInt8](repeating: 0, count: length)
    if let d = self.data(using: .utf8) {
      _ = d.withUnsafeBytes { body -> String in
        CC_SHA1(body.baseAddress, CC_LONG(d.count), &digest)
        return ""
      }
    }
    return (0 ..< length).reduce("") {
      $0 + String(format: "%02x", digest[$1])
    }
  }
}


extension UICollectionView {
  func register<T: UICollectionViewCell>(_: T.Type) {
    let identitifier = String(describing: T.self)
    self.register(UINib(nibName: identitifier, bundle: .main), forCellWithReuseIdentifier: identitifier)
  }
  
  func register<T: UICollectionReusableView>(_: T.Type) {
    let identitifier = String(describing: T.self)
    register(UINib(nibName: identitifier, bundle: .main),
             forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
             withReuseIdentifier: identitifier)
  }
  
  func dequeue<T: UICollectionViewCell>(_: T.Type, indexPath: IndexPath) -> T {
    let identitifier = String(describing: T.self)
    guard let cell = dequeueReusableCell(withReuseIdentifier: identitifier, for: indexPath) as? T
    else { fatalError("Could not dequeue desired cell, something is wrong.")}
    return cell
  }
  
  func dequeueHeader<T: UICollectionReusableView>(_: T.Type, indexPath: IndexPath) -> T {
    let identitifier = String(describing: T.self)
    guard let header = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                        withReuseIdentifier: identitifier,
                                                        for: indexPath) as? T
    else { fatalError("Could not dequeue desired headerView, something is wrong.") }
    return header
  }
}
