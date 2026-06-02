//
//  SplashViewController.swift
//  LokaldeCaseStudy
//
//  Created by Mehmet Biçici on 1.06.2026.
//

import UIKit

private enum Constants {
    static let backgroundColor: UIColor = .splashBackground
    
    enum SplashImageView {
        static let image: UIImage = .splash
    }
    
    enum SplashTitleLabel {
        static let text: String = String(localized: "splash_title", defaultValue: "OKALDE")
        static let font: UIFont = .splashTitle
        static let textColor: UIColor = .white
    }
}

final class SplashViewController: BaseViewController {

    @IBOutlet private weak var splashImageView: UIImageView!
    @IBOutlet private weak var splashTitleLabel: UILabel!
    
    private lazy var viewModel: SplashViewModelInterface = {
        return SplashViewModel(delegate: self)
    }()
    
    weak var navigationDelegate: SplashNavigationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        viewModel.startSplashSequence()
    }
}

private extension SplashViewController {
    func prepareUI() {
        view.backgroundColor = Constants.backgroundColor
        prepareSplashImageView()
        prepareSplashTitleLabel()
    }
    
    func prepareSplashImageView() {
        splashImageView.image = Constants.SplashImageView.image
        splashImageView.makeCircular()
    }
    
    func prepareSplashTitleLabel() {
        splashTitleLabel.textColor = Constants.SplashTitleLabel.textColor
        splashTitleLabel.font = Constants.SplashTitleLabel.font
        splashTitleLabel.text = Constants.SplashTitleLabel.text
    }
}

extension SplashViewController: SplashViewModelDelegate {
    func navigateProvidersPage() {
        navigationDelegate?.navigateToProviderList()
    }
}
