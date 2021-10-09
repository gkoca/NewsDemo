//
//  SceneDelegate.swift
//  News
//
//  Created by Gökhan KOCA on 8.10.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
             options connectionOptions: UIScene.ConnectionOptions) {
    
    guard let windowScene = (scene as? UIWindowScene) else { return }
    let viewController = NewsBuilder.make()
    let window = UIWindow(windowScene: windowScene)
    let navigationController = UINavigationController(rootViewController: viewController)
    navigationController.navigationBar.prefersLargeTitles = true
    window.rootViewController = navigationController
    self.window = window
    self.window?.makeKeyAndVisible()
  }
}

