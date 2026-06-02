//
//  AppButton.swift
//  LokaldeCaseStudy
//
//  Created by Mehmet Biçici on 2.06.2026.
//

import UIKit

// MARK: - Constants
private enum Constants {
    static let cornerRadius: CGFloat = 16.0
    static let height: CGFloat = 56.0
    static let imagePadding: CGFloat = 10.0
}

final class AppButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func configure(title: String,
                   image: UIImage? = nil,
                   bgColor: UIColor,
                   titleColor: UIColor = .white) {
        
        var config = UIButton.Configuration.filled()
        
        config.baseBackgroundColor = bgColor
        config.baseForegroundColor = titleColor
        
        var attributedTitle = AttributedString(title)
        attributedTitle.font = .buttonText
        config.attributedTitle = attributedTitle
        
        if let image = image {
            config.image = image
            config.imagePadding = Constants.imagePadding
        }
        
        config.background.cornerRadius = Constants.cornerRadius
        
        self.configuration = config
    }
}

private extension AppButton {
    func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: Constants.height).isActive = true
    }
}
