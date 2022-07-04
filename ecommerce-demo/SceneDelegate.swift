//
//  SceneDelegate.swift
//  intexsys-test-task
//
//  Created by Vladislav Khomyakov on 30.06.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        // wrap to coordinator
        let categoriesVM = ProductCategoriesViewModel(apiService: OpticsplanetAPIService.shared)
        let categoriesController = ProductCategoriesViewController(viewModel: categoriesVM)
        let navigationController = UINavigationController(rootViewController: categoriesController)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}

