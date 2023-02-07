//
//  SceneDelegate.swift
//  Guide Daechelin
//
//  Created by 이민규 on 2023/02/07.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .white
        window?.rootViewController = UINavigationController(rootViewController: MainVC())
        
        window?.makeKeyAndVisible()
    }
    
}

