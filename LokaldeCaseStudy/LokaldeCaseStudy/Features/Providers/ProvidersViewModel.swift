//
//  ProvidersViewModel.swift
//  LokaldeCaseStudy
//
//  Created by Mehmet Biçici on 2.06.2026.
//

import Foundation

private enum Constants {
    static let country: String = String(localized: "country", defaultValue: "Country")
    static let city: String = String(localized: "city", defaultValue: "City")
    static let services: String = String(localized: "services", defaultValue: "Services")
    static let queryCount: Int = 3
}

protocol ProvidersViewModelDelegate: AnyObject {
    func reloadFilters()
    func reloadProviders()
    func updateLoadingState(show: Bool)
    func showEmptyState()
    func showErrorState(message: String)
}

protocol ProvidersViewModelInterface {
    var filters: [FilterPillModel] { get }
    var providers: [ProviderListTableViewCellModel] { get }
    var searchQuery: String { get }
    
    func loadFilters()
    func loadProviders()
    func updateSearchQuery(_ query: String)
    func toggleFilterSelection(at index: Int)
}

final class ProvidersViewModel: ProvidersViewModelInterface {
    private weak var delegate: ProvidersViewModelDelegate?
    private let providerService: ProviderServiceProtocol
    
    private(set) var filters: [FilterPillModel] = []
    
    private(set) var providers: [ProviderListTableViewCellModel] = []
    private var allProviders: [ProviderListTableViewCellModel] = []
    
    private(set) var searchQuery: String = ""
    
    init(providerService: ProviderServiceProtocol = MockDataService(), delegate: ProvidersViewModelDelegate) {
        self.providerService = providerService
        self.delegate = delegate
    }
    
    func loadFilters() {
        filters = [
            FilterPillModel(title: Constants.country),
            FilterPillModel(title: Constants.city),
            FilterPillModel(title: Constants.services),
        ]
        delegate?.reloadFilters()
    }
    
    func loadProviders() {
        delegate?.updateLoadingState(show: true)
        
        providerService.fetchProviders { [weak self] result in
            guard let self = self else { return }
            
            self.delegate?.updateLoadingState(show: false)
            
            switch result {
            case .success(let dtoList):
                let mappedProviders = dtoList.map { dto in
                    ProviderListTableViewCellModel(
                        id: dto.id,
                        name: dto.name,
                        imageURL: dto.profileImageUrl,
                        specialty: dto.specialty,
                        city: dto.city,
                        rating: dto.rating
                    )
                }
                
                self.allProviders = mappedProviders
                self.providers = mappedProviders
                
                guard !allProviders.isEmpty else {
                    self.delegate?.showEmptyState()
                    return
                }

                self.delegate?.reloadProviders()
                
            case .failure(let error):
                debugPrint("Error details: \(error)")
                self.delegate?.showErrorState(message: String(localized: "error_description", defaultValue: "Something went wrong. Please try again."))
            }
        }
    }
    
    func updateSearchQuery(_ query: String) {
        searchQuery = query
        
        if query.isEmpty {
            providers = allProviders
            delegate?.reloadProviders()
            return
        }
        
        guard query.count >= Constants.queryCount else { return }
        
        let lowercasedQuery = query.lowercased()
        
        providers = allProviders.filter { provider in
            let matchName = provider.name?.lowercased().contains(lowercasedQuery)
            let matchSpecialty = provider.specialty?.lowercased().contains(lowercasedQuery)
            return matchName ?? false || matchSpecialty ?? false
        }
        
        guard !providers.isEmpty else {
            delegate?.showEmptyState()
            return
        }

        delegate?.reloadProviders()
    }
    
    func toggleFilterSelection(at index: Int) {
        filters[index].isSelected.toggle()
        
        let activeFilters = filters.filter { $0.isSelected }.map { $0.title }
        print("Aktif Filtreler: \(activeFilters)")
    }
}
