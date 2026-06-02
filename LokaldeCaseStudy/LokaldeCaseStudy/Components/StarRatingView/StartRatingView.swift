//
//  StartRatingView.swift
//  LokaldeCaseStudy
//
//  Created by Mehmet Biçici on 2.06.2026.
//

import UIKit

private enum Constants {
    static let maxRating: CGFloat = 5.0
}

final class StarRatingView: UIView {
    
    private let emptyStarsStackView = UIStackView()
    private let filledStarsStackView = UIStackView()
    
    private let filledStarsContainer = UIView()
    
    private var containerWidthConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func configure(with rating: Double, starSize: CGFloat = 16.0, spacing: CGFloat = 4.0) {
        let clampedRating = max(0.0, min(CGFloat(rating), Constants.maxRating))
        
        setupStars(stackView: emptyStarsStackView, isFilled: false, size: starSize, spacing: spacing)
        setupStars(stackView: filledStarsStackView, isFilled: true, size: starSize, spacing: spacing)
        
        let ratio = clampedRating / Constants.maxRating
        
        containerWidthConstraint?.isActive = false
        containerWidthConstraint = filledStarsContainer.widthAnchor.constraint(equalTo: emptyStarsStackView.widthAnchor, multiplier: ratio)
        containerWidthConstraint?.isActive = true
        
        layoutIfNeeded()
    }
}

private extension StarRatingView {
    func setupUI() {
        backgroundColor = .clear
        
        emptyStarsStackView.translatesAutoresizingMaskIntoConstraints = false
        filledStarsStackView.translatesAutoresizingMaskIntoConstraints = false
        filledStarsContainer.translatesAutoresizingMaskIntoConstraints = false
        
        filledStarsContainer.clipsToBounds = true
        
        addSubview(emptyStarsStackView)
        addSubview(filledStarsContainer)
        filledStarsContainer.addSubview(filledStarsStackView)
        
        NSLayoutConstraint.activate([
            emptyStarsStackView.topAnchor.constraint(equalTo: topAnchor),
            emptyStarsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            emptyStarsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            emptyStarsStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            filledStarsContainer.topAnchor.constraint(equalTo: topAnchor),
            filledStarsContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            filledStarsContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            filledStarsStackView.topAnchor.constraint(equalTo: filledStarsContainer.topAnchor),
            filledStarsStackView.leadingAnchor.constraint(equalTo: filledStarsContainer.leadingAnchor),
            filledStarsStackView.bottomAnchor.constraint(equalTo: filledStarsContainer.bottomAnchor),
            filledStarsStackView.widthAnchor.constraint(equalTo: emptyStarsStackView.widthAnchor)
        ])
    }
    
    func setupStars(stackView: UIStackView, isFilled: Bool, size: CGFloat, spacing: CGFloat) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = spacing
        
        let imageName = isFilled ? "star.fill" : "star"
        let tintColor: UIColor = isFilled ? UIColor.tertiary : .systemGray5
        
        for _ in 0..<Int(Constants.maxRating) {
            let imageView = UIImageView()
            imageView.image = UIImage(systemName: imageName)
            imageView.tintColor = tintColor
            imageView.contentMode = .scaleAspectFit
            
            imageView.widthAnchor.constraint(equalToConstant: size).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: size).isActive = true
            
            stackView.addArrangedSubview(imageView)
        }
    }
}
