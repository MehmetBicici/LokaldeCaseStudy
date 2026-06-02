//
//  AppCordinator.swift
//  LokaldeCaseStudy
//
//  Created by Mehmet Biçici on 2.06.2026.
//

import UIKit

private enum Constants {
    static let duration: CGFloat = 0.5
    static let splashNibName: String = "SplashViewController"
}

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    func start()
}

protocol SplashNavigationDelegate: AnyObject {
    func navigateToProviderList()
}

protocol ProvidersNavigationDelegate: AnyObject {
    func presentFilterSheet(for type: FilterType,
                            filterDelegate: FiltersViewControllerDelegate,
                            activeFilters: [String],
                            availableOptions: [String])
    func navigateToProviderDetails(with provider: ProviderDTO)
}

protocol ProviderDetailsNavigationDelegate: AnyObject {
   
}

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    private var window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
        self.navigationController = UINavigationController()
    }
    
    func start() {
        let splashVC = SplashViewController(nibName: Constants.splashNibName,
                                            bundle: nil)
        splashVC.navigationDelegate = self
        
        navigationController.setViewControllers([splashVC], animated: false)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

extension AppCoordinator: SplashNavigationDelegate {
    func navigateToProviderList() {
        let providerListVC = ProvidersViewController()
        
        providerListVC.navigationDelegate = self
        
        UIView.transition(with: navigationController.view,
                          duration: Constants.duration,
                          options: .transitionCrossDissolve,
                          animations: {
            self.navigationController.setViewControllers([providerListVC], animated: false)
        }, completion: nil)
    }
}

extension AppCoordinator: ProvidersNavigationDelegate {
    func presentFilterSheet(for type: FilterType,
                            filterDelegate: FiltersViewControllerDelegate,
                            activeFilters: [String],
                            availableOptions: [String]) {
        
        let filterViewModel = FiltersViewModel(filterType: type,
                                               activeSelection: activeFilters,
                                               availableOptions: availableOptions)
        
        let filterVC = FiltersViewController(viewModel: filterViewModel, delegate: filterDelegate)
        
        if let sheet = filterVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = false
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        
        navigationController.present(filterVC, animated: true)
    }
    
    func navigateToProviderDetails(with provider: ProviderDTO) {
        let detailsVC = ProviderDetailsViewController()
        
        detailsVC.providerDTO = provider
        detailsVC.navigationDelegate = self
        
        navigationController.pushViewController(detailsVC, animated: true)
    }
}

extension AppCoordinator: ProviderDetailsNavigationDelegate {

}
