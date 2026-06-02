//
//  ProviderDetailsViewModel.swift
//  LokaldeCaseStudy
//
//  Created by Mehmet Biçici on 2.06.2026.
//

import Foundation

protocol ProviderDetailsViewModelDelegate: AnyObject {
    func updateUI(with model: ProviderDetailsModel)
}

protocol ProviderDetailsViewModelInterface {
    func viewDidLoad()
    func didTapBookAppointment()
    func didTapLike()
}

final class ProviderDetailsViewModel: ProviderDetailsViewModelInterface {
    
    private weak var delegate: ProviderDetailsViewModelDelegate?
    private let provider: ProviderDTO
    
    init(provider: ProviderDTO,
         delegate: ProviderDetailsViewModelDelegate) {
        self.provider = provider
        self.delegate = delegate
    }
    
    func viewDidLoad() {
        prepareUIModel()
    }
    
    private func prepareUIModel() {
        let model = ProviderDetailsModel(
            imageURL: provider.profileImageUrl,
            name: provider.name ?? "Unknown",
            specialty: provider.specialty ?? "Not Specified",
            rating: provider.rating ?? 0.0,
            ratingText: String(format: "%.1f", provider.rating ?? 0.0),
            bio: provider.bio ?? "Biography is not available.",
            phone: provider.contactInfo?.phone ?? "No phone number",
            email: provider.contactInfo?.email ?? "No email address",
            address: provider.contactInfo?.address ?? "No location specified"
        )
        
        delegate?.updateUI(with: model)
    }
    
    func didTapBookAppointment() {
        print("Tapped Book Appointment: \(provider.name ?? "")")
    }
    
    func didTapLike() {
        print("Tapped Favorite: \(provider.name ?? "")")
    }
}
