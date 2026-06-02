//
//  FiltersTableViewCell.swift
//  LokaldeCaseStudy
//
//  Created by Mehmet Biçici on 2.06.2026.
//

import UIKit

private enum Constants {
    static let backgroundColor: UIColor = .clear
    
    enum ContainerView {
        static let selectedBackgroundColor: UIColor = .systemGray6
        static let unselectedBackgroundColor: UIColor = .clear
        static let cornerRadius: CGFloat = 16
    }
    
    enum FilterOptionLabel {
        static let selectedFont: UIFont = .headline
        static let unselectedFont: UIFont = .text
        static let textColor: UIColor = .subtitle
    }
    
    enum SelectedImageView {
        static let image: UIImage = .selectedFilterIcon
    }
}

final class FiltersTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var filterOptionLabel: UILabel!
    @IBOutlet private weak var selectedImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        filterOptionLabel.text = nil
        updateSelectionState(isSelected: false)
    }
    
    func configure(with model: FilterOptionModel) {
        filterOptionLabel.text = model.title
        updateSelectionState(isSelected: model.isSelected)
    }
}

private extension FiltersTableViewCell {
    func prepareUI() {
        selectionStyle = .none
        backgroundColor = Constants.backgroundColor
        
        containerView.layer.cornerRadius = Constants.ContainerView.cornerRadius
        containerView.layer.masksToBounds = true
        
        filterOptionLabel.textColor = Constants.FilterOptionLabel.textColor
        selectedImageView.image = Constants.SelectedImageView.image
        
        selectedImageView.isHidden = true
    }
    
    func updateSelectionState(isSelected: Bool) {
        selectedImageView.isHidden = !isSelected

        containerView.backgroundColor = isSelected
            ? Constants.ContainerView.selectedBackgroundColor
            : Constants.ContainerView.unselectedBackgroundColor

        filterOptionLabel.font = isSelected
            ? Constants.FilterOptionLabel.selectedFont
            : Constants.FilterOptionLabel.unselectedFont
    }
}
