//
//  InfoStateView.swift
//  LokaldeCaseStudy
//
//  Created by Mehmet Biçici on 2.06.2026.
//

import UIKit

// MARK: - Constants
private enum Constants {
    
    static let backgroundColor: UIColor = .clear
    
    enum Strings {
        static let errorTitle: String = String(localized: "error_title", defaultValue: "Error")
        static let emptySearchTitle: String = String(localized: "search_empty_title", defaultValue: "No providers found")
        static let retryButton: String = String(localized: "try_again", defaultValue: "Try Again")
        static let emptySearchDescription: String = String(localized: "search_empty_description", defaultValue: "Try adjusting your filters or searching for a different specialty or location.")
    }
    
    enum Icons {
        static let error: UIImage = .errorIcon
        static let emptySearch: UIImage = .emptySearchIcon
    }
    
    enum Layout {
        static let iconSize: CGFloat = 100.0
        static let stackSpacing: CGFloat = 16.0
        static let stackCustomSpacing: CGFloat = 24.0
        static let buttonMinWidth: CGFloat = 200.0
        static let horizontalPadding: CGFloat = 32.0
        static let animationDuration: TimeInterval = 0.3
    }
    
    enum Fonts {
        static let title: UIFont = .headline
        static let description: UIFont = .text
    }
    
    enum Colors {
        static let titleColor: UIColor = .title
        static let descriptionColor: UIColor = .secondary
    }
    
    enum RetryButton {
        static let image: UIImage = .retryIcon
        static let backgroundColor: UIColor = .primary
        static let titleColor: UIColor = .white
    }
}

// MARK: - Delegate Protocol
protocol InfoStateViewDelegate: AnyObject {
    func didTapRetryButton()
}

enum InfoStateType {
    case error(message: String)
    case emptySearch
    
    var iconImage: UIImage? {
        switch self {
        case .error: return Constants.Icons.error
        case .emptySearch: return Constants.Icons.emptySearch
        }
    }
    
    var title: String {
        switch self {
        case .error: return Constants.Strings.errorTitle
        case .emptySearch: return Constants.Strings.emptySearchTitle
        }
    }
    
    var description: String {
        switch self {
        case .error(let message): return message
        case .emptySearch: return Constants.Strings.emptySearchDescription
        }
    }
}

final class InfoStateView: UIView {
    
    private weak var delegate: InfoStateViewDelegate?
    
    private let containerStackView = UIStackView()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let actionButton = AppButton()
    
    
    init(delegate: InfoStateViewDelegate? = nil) {
        self.delegate = delegate
        super.init(frame: .zero)
        prepareUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented. Use programmatic init.")
    }
    
    func configure(with state: InfoStateType) {
        iconImageView.image = state.iconImage
        titleLabel.text = state.title
        descriptionLabel.text = state.description
        
        switch state {
        case .error:
            actionButton.configure(title: Constants.Strings.retryButton,
                                   image: Constants.RetryButton.image, bgColor: Constants.RetryButton.backgroundColor,
                                   titleColor: Constants.RetryButton.titleColor)
            actionButton.isHidden = false
            
            UIView.animate(withDuration: Constants.Layout.animationDuration) { [weak self] in
                guard let self = self else { return }
                self.layoutIfNeeded()
            }
        case .emptySearch:
            actionButton.isHidden = true
        }
    }
}

@objc
private extension InfoStateView {
    func retryButtonTapped() {
        delegate?.didTapRetryButton()
    }
}

private extension InfoStateView {
    func prepareUI() {
        backgroundColor = Constants.backgroundColor
        setupContainerStackView()
        setupIconImageView()
        setupTitleLabel()
        setupDescriptionLabel()
        setupActionButton()
        layoutComponents()
    }
    
    func setupContainerStackView() {
        containerStackView.axis = .vertical
        containerStackView.alignment = .center
        containerStackView.spacing = Constants.Layout.stackSpacing
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupIconImageView() {
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupTitleLabel() {
        titleLabel.font = Constants.Fonts.title
        titleLabel.textColor = Constants.Colors.titleColor
        titleLabel.textAlignment = .center
    }
    
    func setupDescriptionLabel() {
        descriptionLabel.font = Constants.Fonts.description
        descriptionLabel.textColor = Constants.Colors.descriptionColor
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = .zero
    }
    
    func setupActionButton() {
        actionButton.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
    }
    
    func layoutComponents() {
        addSubview(containerStackView)
        
        containerStackView.addArrangedSubview(iconImageView)
        containerStackView.addArrangedSubview(titleLabel)
        containerStackView.addArrangedSubview(descriptionLabel)
        
        containerStackView.setCustomSpacing(Constants.Layout.stackCustomSpacing, after: descriptionLabel)
        containerStackView.addArrangedSubview(actionButton)
        
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: Constants.Layout.iconSize),
            iconImageView.heightAnchor.constraint(equalToConstant: Constants.Layout.iconSize),
            actionButton.widthAnchor.constraint(equalTo: containerStackView.widthAnchor),
            containerStackView.topAnchor.constraint(equalTo: topAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
