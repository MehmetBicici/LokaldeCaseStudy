//
//  SplashViewModel.swift
//  LokaldeCaseStudy
//
//  Created by Mehmet Biçici on 1.06.2026.
//

import Foundation

private enum Constants {
    static let delay: CGFloat = 1.0
}

protocol SplashViewModelDelegate: AnyObject {
    func navigateProvidersPage()
}

protocol SplashViewModelInterface {
    func startSplashSequence()
}

final class SplashViewModel: SplashViewModelInterface {
    private weak var delegate: SplashViewModelDelegate?
    
    init(delegate: SplashViewModelDelegate) {
        self.delegate = delegate
    }
    
    func startSplashSequence() {
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.delay) { [weak self] in
            guard let self = self else { return }
            delegate?.navigateProvidersPage()
        }
    }
}
