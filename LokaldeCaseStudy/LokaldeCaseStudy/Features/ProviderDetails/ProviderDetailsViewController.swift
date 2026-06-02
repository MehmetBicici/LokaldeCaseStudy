//
//  ProviderDetailsViewController.swift
//  LokaldeCaseStudy
//
//  Created by Mehmet Biçici on 2.06.2026.
//

import UIKit
import Kingfisher

private enum Constants {
    static let backgroundColor: UIColor = .background
    static let title: String = String(localized: "provider_details_title", defaultValue: "Provider Details")
    static let titleColor: UIColor = .title
    static let backButtonColor: UIColor = .primary
    
    enum ProviderImageContainerView {
        static let backgroundColor: UIColor = .white
        static let shadowColor: UIColor = .black
        static let shadowOpacity: Float = 0.15
        static let shadowOffset: CGSize = CGSize(width: 0, height: 6)
        static let shadowRadius: CGFloat = 12
    }
    
    enum ProviderImageView {
        static let contentMode: UIView.ContentMode = .scaleAspectFill
    }
    
    enum ProviderNameLabel {
        static let textColor: UIColor = .title
        static let font: UIFont = .title
        static let textAlignment: NSTextAlignment = .center
    }
    
    enum ProviderTitleLabel {
        static let textColor: UIColor = .secondary
        static let font: UIFont = .text
        static let textAlignment: NSTextAlignment = .center
    }
    
    enum RatingLabel {
        static let textColor: UIColor = .subtitle
        static let font: UIFont = .text
        static let textAlignment: NSTextAlignment = .left
        static let text: String = String(localized: "rate", defaultValue: "Rate")
    }
    
    enum BookingButton {
        static let title: String = String(localized: "book_appointment_button_title", defaultValue: "Book Appointment")
        static let titleColor: UIColor = .white
        static let backgroundColor: UIColor = .primary
    }
    
    enum LikeButton {
        static let image: UIImage = .likeIcon
        static let borderWidth: CGFloat = 1
        static let borderColor: UIColor = .systemGray5
        static let cornerRadius: CGFloat = 12
        static let backgroundColor: UIColor = .clear
    }
    
    enum BiographyTitleLabel {
        static let textColor: UIColor = .title
        static let font: UIFont = .headline
        static let title: String = String(localized: "biography_title", defaultValue: "Biography")
    }
    
    enum BiographyDescriptionContainerView {
        static let backgroundColor: UIColor = .soft
        static let cornerRadius: CGFloat = 8
    }
    
    enum BiographyDescriptionLabel {
        static let textColor: UIColor = .secondary
        static let font: UIFont = .text
    }
    
    enum ContactTitleLabel {
        static let textColor: UIColor = .title
        static let font: UIFont = .headline
        static let title: String = String(localized: "contact_information_title", defaultValue: "Contact Information")
    }
    
    enum ContactContainerView {
        static let backgroundColor: UIColor = .white
        static let cornerRadius: CGFloat = 12
        static let shadowColor: UIColor = .black
        static let shadowOpacity: Float = 0.08
        static let shadowOffset: CGSize = CGSize(width: 0, height: 4)
        static let shadowRadius: CGFloat = 8
    }
    
    enum PhoneSection {
        static let title: String = String(localized: "phone_title", defaultValue: "Phone")
        static let titleColor: UIColor = .secondary
        static let titleFont: UIFont = .text
        static let phoneLabelColor: UIColor = .subtitle
        static let phoneLabelFont: UIFont = .text
        static let image: UIImage = .phoneIcon
    }
    
    enum EmailSection {
        static let title: String = String(localized: "email_title", defaultValue: "Email")
        static let titleColor: UIColor = .secondary
        static let titleFont: UIFont = .text
        static let phoneLabelColor: UIColor = .subtitle
        static let phoneLabelFont: UIFont = .text
        static let image: UIImage = .emailIcon
    }
    
    enum LocationSection {
        static let title: String = String(localized: "location_title", defaultValue: "Location")
        static let titleColor: UIColor = .secondary
        static let titleFont: UIFont = .text
        static let phoneLabelColor: UIColor = .subtitle
        static let phoneLabelFont: UIFont = .text
        static let image: UIImage = .locationIcon
    }
    
    enum StarRatingView {
        static let starSize: CGFloat = 16.0
        static let spacing: CGFloat = 4.0
    }
}

final class ProviderDetailsViewController: BaseViewController {
    
    @IBOutlet weak var providerImageContainerView: UIView!
    @IBOutlet weak var providerImageView: UIImageView!
    @IBOutlet weak var providerNameLabel: UILabel!
    @IBOutlet weak var starRatingView: StarRatingView!
    @IBOutlet weak var providerTitleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var bookingButton: AppButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var biographyTitleLabel: UILabel!
    @IBOutlet weak var biographyDescriptionContainerView: UIView!
    
    @IBOutlet weak var biographyDescriptionLabel: UILabel!
    @IBOutlet weak var contactTitleLabel: UILabel!
    @IBOutlet weak var contactContainerView: UIStackView!
    
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var phoneTitleLabel: UILabel!
    @IBOutlet weak var phoneImageView: UIImageView!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTitleLabel: UILabel!
    @IBOutlet weak var emailImageView: UIImageView!
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationTitleLabel: UILabel!
    @IBOutlet weak var locationImageView: UIImageView!
    
    weak var navigationDelegate: ProviderDetailsNavigationDelegate?
    
    var providerDTO: ProviderDTO!
    
    private lazy var viewModel: ProviderDetailsViewModelInterface = {
        return ProviderDetailsViewModel(provider: providerDTO, delegate: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        viewModel.viewDidLoad()
    }
}

@objc
private extension ProviderDetailsViewController {
    func bookingButtonTapped() {
        viewModel.didTapBookAppointment()
    }
    
    func likeButtonTapped() {
        viewModel.didTapLike()
    }
    
    func phoneTapped() {
        guard let phone = phoneLabel.text, !phone.isEmpty else { return }
        
        let cleanPhone = phone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        if let url = URL(string: "tel://+\(cleanPhone)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    func emailTapped() {
        guard let email = emailLabel.text, !email.isEmpty else { return }
        
        if let url = URL(string: "mailto:\(email)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    func locationTapped() {
        guard let address = locationLabel.text, !address.isEmpty else { return }
        
        guard let encodedAddress = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        let appleMapsURLString = "maps://?q=\(encodedAddress)"
        
        if let appleMapsURL = URL(string: appleMapsURLString), UIApplication.shared.canOpenURL(appleMapsURL) {
            UIApplication.shared.open(appleMapsURL)
        }
    }
}

private extension ProviderDetailsViewController {
    
    func prepareUI() {
        view.backgroundColor = Constants.backgroundColor
        prepareNavigation()
        prepareProviderHeader()
        prepareButtons()
        prepareBiographySection()
        prepareContactSection()
    }
    
    func prepareNavigation() {
        title = Constants.title
        
        let appearance = UINavigationBarAppearance()
        
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Constants.backgroundColor 
        
        appearance.titleTextAttributes = [.foregroundColor: Constants.titleColor]
        
        appearance.shadowColor = .clear
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        if #available(iOS 15.0, *) {
            navigationController?.navigationBar.compactScrollEdgeAppearance = appearance
        }
        
        navigationItem.backButtonDisplayMode = .minimal
        
        navigationController?.navigationBar.tintColor = Constants.backButtonColor
    }
    
    func prepareProviderHeader() {
        providerImageContainerView.backgroundColor = Constants.ProviderImageContainerView.backgroundColor
        providerImageContainerView.makeCircular()
        providerImageContainerView.layer.masksToBounds = false
        providerImageContainerView.layer.shadowColor = Constants.ProviderImageContainerView.shadowColor.cgColor
        providerImageContainerView.layer.shadowOpacity = Constants.ProviderImageContainerView.shadowOpacity
        providerImageContainerView.layer.shadowOffset = Constants.ProviderImageContainerView.shadowOffset
        providerImageContainerView.layer.shadowRadius = Constants.ProviderImageContainerView.shadowRadius
        
        providerImageView.makeCircular()
        providerImageView.contentMode = Constants.ProviderImageView.contentMode
        
        providerNameLabel.textColor = Constants.ProviderNameLabel.textColor
        providerNameLabel.font = Constants.ProviderNameLabel.font
        providerNameLabel.textAlignment = Constants.ProviderNameLabel.textAlignment
        
        providerTitleLabel.textColor = Constants.ProviderTitleLabel.textColor
        providerTitleLabel.font = Constants.ProviderTitleLabel.font
        providerTitleLabel.textAlignment = Constants.ProviderTitleLabel.textAlignment
        
        ratingLabel.textColor = Constants.RatingLabel.textColor
        ratingLabel.font = Constants.RatingLabel.font
        ratingLabel.textAlignment = Constants.RatingLabel.textAlignment
    }
    
    func prepareButtons() {
        bookingButton.configure(
            title: Constants.BookingButton.title,
            bgColor: Constants.BookingButton.backgroundColor,
            titleColor: Constants.BookingButton.titleColor
        )
        
        bookingButton.addTarget(self, action: #selector(bookingButtonTapped), for: .touchUpInside)
        
        likeButton.setImage(Constants.LikeButton.image, for: .normal)
        likeButton.layer.borderWidth = Constants.LikeButton.borderWidth
        likeButton.layer.borderColor = Constants.LikeButton.borderColor.cgColor
        likeButton.layer.cornerRadius = Constants.LikeButton.cornerRadius
        likeButton.backgroundColor = Constants.LikeButton.backgroundColor
        
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
    }
    
    func prepareBiographySection() {
        biographyTitleLabel.text = Constants.BiographyTitleLabel.title
        biographyTitleLabel.textColor = Constants.BiographyTitleLabel.textColor
        biographyTitleLabel.font = Constants.BiographyTitleLabel.font
        
        biographyDescriptionContainerView.backgroundColor = Constants.BiographyDescriptionContainerView.backgroundColor
        biographyDescriptionContainerView.layer.cornerRadius = Constants.BiographyDescriptionContainerView.cornerRadius
        
        biographyDescriptionLabel.textColor = Constants.BiographyDescriptionLabel.textColor
        biographyDescriptionLabel.font = Constants.BiographyDescriptionLabel.font
        biographyDescriptionLabel.numberOfLines = .zero
    }
    
    func prepareContactSection() {
        contactTitleLabel.text = Constants.ContactTitleLabel.title
        contactTitleLabel.textColor = Constants.ContactTitleLabel.textColor
        contactTitleLabel.font = Constants.ContactTitleLabel.font
        
        contactContainerView.backgroundColor = Constants.ContactContainerView.backgroundColor
        contactContainerView.layer.cornerRadius = Constants.ContactContainerView.cornerRadius
        
        contactContainerView.layer.masksToBounds = false
        contactContainerView.layer.shadowColor = Constants.ContactContainerView.shadowColor.cgColor
        contactContainerView.layer.shadowOpacity = Constants.ContactContainerView.shadowOpacity
        contactContainerView.layer.shadowOffset = Constants.ContactContainerView.shadowOffset
        contactContainerView.layer.shadowRadius = Constants.ContactContainerView.shadowRadius
        
        phoneTitleLabel.text = Constants.PhoneSection.title
        phoneTitleLabel.textColor = Constants.PhoneSection.titleColor
        phoneTitleLabel.font = Constants.PhoneSection.titleFont
        phoneLabel.textColor = Constants.PhoneSection.phoneLabelColor
        phoneLabel.font = Constants.PhoneSection.phoneLabelFont
        phoneImageView.image = Constants.PhoneSection.image
        
        emailTitleLabel.text = Constants.EmailSection.title
        emailTitleLabel.textColor = Constants.EmailSection.titleColor
        emailTitleLabel.font = Constants.EmailSection.titleFont
        emailLabel.textColor = Constants.EmailSection.phoneLabelColor
        emailLabel.font = Constants.EmailSection.phoneLabelFont
        emailImageView.image = Constants.EmailSection.image
        
        locationTitleLabel.text = Constants.LocationSection.title
        locationTitleLabel.textColor = Constants.LocationSection.titleColor
        locationTitleLabel.font = Constants.LocationSection.titleFont
        locationLabel.textColor = Constants.LocationSection.phoneLabelColor
        locationLabel.font = Constants.LocationSection.phoneLabelFont
        locationImageView.image = Constants.LocationSection.image
        
        phoneLabel.isUserInteractionEnabled = true
        phoneLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(phoneTapped)))
        
        emailLabel.isUserInteractionEnabled = true
        emailLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(emailTapped)))
        
        locationLabel.isUserInteractionEnabled = true
        locationLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(locationTapped)))
    }
}


extension ProviderDetailsViewController: ProviderDetailsViewModelDelegate {
    
    func updateUI(with model: ProviderDetailsModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.providerNameLabel.text = model.name
            self.providerTitleLabel.text = model.specialty
            self.ratingLabel.text = (model.ratingText ?? "") + " " + Constants.RatingLabel.text
            self.biographyDescriptionLabel.text = model.bio
            self.phoneLabel.text = model.phone
            self.emailLabel.text = model.email
            self.locationLabel.text = model.address
            
            self.starRatingView.configure(with: model.rating ?? .zero,
                                          starSize: Constants.StarRatingView.starSize,
                                          spacing: Constants.StarRatingView.spacing)
            
            
            if let urlString = model.imageURL, let url = URL(string: urlString) {
                self.providerImageView.kf.setImage(with: url)
            }
            
        }
    }
}
