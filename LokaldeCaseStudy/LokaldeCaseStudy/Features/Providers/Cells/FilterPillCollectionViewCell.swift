//
//  FilterPillCollectionViewCell.swift
//  LokaldeCaseStudy
//
//  Created by Mehmet Biçici on 2.06.2026.
//

import UIKit

import UIKit

private enum Constants {
    
    enum ContainerView {
        static let unselectedBackground: UIColor = .white
        static let selectedBackground: UIColor = .primary
        static let borderColor: UIColor = .stroke.withAlphaComponent(0.5)
        static let borderWidth: CGFloat = 1.0
        static let cornerRadius: CGFloat = 18
    }
    
    enum FilterLabel {
        static let selectedText: UIColor = .white
        static let unselectedText: UIColor = .subtitle
        static let font: UIFont = .text
    }
}

final class FilterPillCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var filterLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            updateState(isSelected: isSelected)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.cornerRadius = Constants.ContainerView.cornerRadius
    }
    
    func configure(with model: FilterPillModel) {
        filterLabel.text = model.title
        updateState(isSelected: model.isSelected)
    }
}

private extension FilterPillCollectionViewCell {
    func setupUI() {
        setupFilterLabel()
        setupContainerView()
    }
    
    func setupFilterLabel() {
        filterLabel.font = Constants.FilterLabel.font
    }
    
    func setupContainerView() {
        containerView.clipsToBounds = true
    }
}

private extension FilterPillCollectionViewCell {
    func updateState(isSelected: Bool) {
        guard isSelected else {
            containerView.backgroundColor = Constants.ContainerView.unselectedBackground
            containerView.layer.borderWidth = Constants.ContainerView.borderWidth
            containerView.layer.borderColor = Constants.ContainerView.borderColor.cgColor
            filterLabel.textColor = Constants.FilterLabel.unselectedText
            return
        }

        containerView.backgroundColor = Constants.ContainerView.selectedBackground
        containerView.layer.borderWidth = .zero
        filterLabel.textColor = Constants.FilterLabel.selectedText
    }
}
