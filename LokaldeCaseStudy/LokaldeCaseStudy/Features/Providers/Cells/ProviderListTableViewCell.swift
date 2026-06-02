//
//  ProviderListTableViewCell.swift
//  LokaldeCaseStudy
//
//  Created by Mehmet Biçici on 2.06.2026.
//

import UIKit
import Kingfisher

private enum Constants {
    static let backgroundColor: UIColor = .white
    static let starImage = UIImage(systemName: "star.fill")
    static let starTintColor: UIColor = .tertiary
    static let cornerRadius: CGFloat = 12.0
    
    enum Shadow {
        static let color: CGColor = UIColor.black.cgColor
        static let opacity: Float = 0.08
        static let offset = CGSize(width: 0, height: 4)
        static let radius: CGFloat = 8.0
    }
    
    enum Fonts {
        static let name: UIFont = .headline
        static let subtitle: UIFont = .text
        static let score: UIFont = .headline
    }
    
    enum Colors {
        static let name: UIColor = .subtitle
        static let subtitle: UIColor = .secondary
        static let score: UIColor = .secondary
    }
    
    enum ContainerView {
        static let borderColor: UIColor = .stroke.withAlphaComponent(0.5)
        static let borderWidth: CGFloat = 1.0
        static let backgroundColor: UIColor = .clear
    }
    
    enum Animation {
        static let duration: CGFloat = 0.3
    }
    
    enum ProviderThumbnailImageView {
        static let placeholderImage: UIImage = UIImage(systemName: "person.circle.fill")?.withTintColor(.systemGray5, renderingMode: .alwaysOriginal) ?? UIImage()
    }
}

final class ProviderListTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var providerNameLabel: UILabel!
    @IBOutlet private weak var providerThumbnailImageView: UIImageView!
    @IBOutlet private weak var providerLocationAndServiceLabel: UILabel!
    @IBOutlet private weak var starImageView: UIImageView!
    @IBOutlet private weak var providerScoreLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        providerThumbnailImageView.makeCircular()
        containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: Constants.cornerRadius).cgPath
    }
    
    func configure(with model: ProviderListTableViewCellModel) {
        providerNameLabel.text = model.name
        providerLocationAndServiceLabel.text = model.subtitle
        providerScoreLabel.text = model.ratingText

        guard let urlString = model.imageURL,
              let url = URL(string: urlString)
        else {
            providerThumbnailImageView.image = Constants.ProviderThumbnailImageView.placeholderImage
            return
        }

        providerThumbnailImageView.kf.indicatorType = .activity

        providerThumbnailImageView.kf.setImage(
            with: url,
            placeholder: nil,
            options: [
                .transition(.fade(Constants.Animation.duration)),
                .cacheOriginalImage
            ]
        )
    }
}

private extension ProviderListTableViewCell {
    func setupUI() {
        selectionStyle = .none
        
        backgroundColor = Constants.ContainerView.backgroundColor
        contentView.backgroundColor = Constants.ContainerView.backgroundColor
        
        containerView.backgroundColor = Constants.backgroundColor
        containerView.layer.cornerRadius = Constants.cornerRadius
        
        containerView.layer.masksToBounds = false
        
        containerView.layer.shadowColor = Constants.Shadow.color
        containerView.layer.shadowOpacity = Constants.Shadow.opacity
        containerView.layer.shadowOffset = Constants.Shadow.offset
        containerView.layer.shadowRadius = Constants.Shadow.radius
        containerView.layer.borderWidth = Constants.ContainerView.borderWidth
        containerView.layer.borderColor = Constants.ContainerView.borderColor.cgColor
        
        providerNameLabel.font = Constants.Fonts.name
        providerNameLabel.textColor = Constants.Colors.name
        
        providerLocationAndServiceLabel.font = Constants.Fonts.subtitle
        providerLocationAndServiceLabel.textColor = Constants.Colors.subtitle
        
        providerScoreLabel.font = Constants.Fonts.score
        providerScoreLabel.textColor = Constants.Colors.score
        
        starImageView.image = Constants.starImage
        starImageView.tintColor = Constants.starTintColor
        
        providerThumbnailImageView.contentMode = .scaleAspectFill
        providerThumbnailImageView.clipsToBounds = true
    }
}
