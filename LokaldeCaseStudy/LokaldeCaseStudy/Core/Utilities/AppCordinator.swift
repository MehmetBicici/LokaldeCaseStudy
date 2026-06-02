//
//  AppCordinator.swift
//  LokaldeCaseStudy
//
//  Created by Mehmet Biçici on 2.06.2026.
//

import UIKit

private enum Constants {
    static let duration: CGFloat = 0.5
}

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    func start()
}

protocol SplashNavigationDelegate: AnyObject {
    func navigateToProviderList()
}

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    private var window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
        self.navigationController = UINavigationController()
    }
    
    func start() {
        let splashVC = SplashViewController(nibName: "SplashViewController", bundle: nil)
        splashVC.navigationDelegate = self
        
        navigationController.setViewControllers([splashVC], animated: false)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

// MARK: - SplashNavigationDelegate
extension AppCoordinator: SplashNavigationDelegate {
    func navigateToProviderList() {
        let providerListVC = ProvidersViewController()
        
        UIView.transition(with: navigationController.view,
                          duration: Constants.duration,
                          options: .transitionCrossDissolve,
                          animations: {
            self.navigationController.setViewControllers([providerListVC], animated: false)
        }, completion: nil)
    }
}
