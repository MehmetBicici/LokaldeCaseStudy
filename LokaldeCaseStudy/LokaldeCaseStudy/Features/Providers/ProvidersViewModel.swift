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
    
    func getActiveFilters(for type: FilterType) -> [String]
    func loadFilters()
    func loadProviders()
    func updateSearchQuery(_ query: String)
    func applyFilter(options: [FilterOptionModel], for type: FilterType)
    func getAvailableOptions(for type: FilterType) -> [String]
}

final class ProvidersViewModel: ProvidersViewModelInterface {
    private weak var delegate: ProvidersViewModelDelegate?
    private let providerService: ProviderServiceProtocol
    
    private(set) var filters: [FilterPillModel] = []
    
    private(set) var providers: [ProviderListTableViewCellModel] = []
    private var allProviders: [ProviderListTableViewCellModel] = []
    
    private(set) var searchQuery: String = ""
    private var activeCountryFilters: [String] = []
    private var activeCityFilters: [String] = []
    private var activeServiceFilters: [String] = []
    
    private var availableCountries: [String] = []
    private var availableCities: [String] = []
    private var availableServices: [String] = []
    
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
                        rating: dto.rating,
                        country: dto.country
                    )
                }
                
                self.allProviders = mappedProviders
                self.providers = mappedProviders
                
                let uniqueCountries = Set(dtoList.compactMap { $0.country })
                let uniqueCities = Set(dtoList.compactMap { $0.city })
                let uniqueServices = Set(dtoList.compactMap { $0.specialty })
                
                self.availableCountries = Array(uniqueCountries).sorted()
                self.availableCities = Array(uniqueCities).sorted()
                self.availableServices = Array(uniqueServices).sorted()
                
                guard !self.allProviders.isEmpty else {
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
        
        applyAllFilters()
    }
    
    func applyFilter(options: [FilterOptionModel], for type: FilterType) {
        let selectedTitles = options.map { $0.title }
        let hasActiveFilters = !selectedTitles.isEmpty
        
        switch type {
        case .country:
            activeCountryFilters = selectedTitles
            filters[0].isSelected = hasActiveFilters
        case .city:
            activeCityFilters = selectedTitles
            filters[1].isSelected = hasActiveFilters
        case .services:
            activeServiceFilters = selectedTitles
            filters[2].isSelected = hasActiveFilters
        }
        
        delegate?.reloadFilters()
        
        applyAllFilters()
    }
    
    func getActiveFilters(for type: FilterType) -> [String] {
        switch type {
        case .country: return activeCountryFilters
        case .city: return activeCityFilters
        case .services: return activeServiceFilters
        }
    }
    
    func getAvailableOptions(for type: FilterType) -> [String] {
        switch type {
        case .country: return availableCountries
        case .city: return availableCities
        case .services: return availableServices
        }
    }
}

private extension ProvidersViewModel {
    func applyAllFilters() {
        let isSearchActive = !searchQuery.isEmpty && searchQuery.count >= Constants.queryCount
        let query = isSearchActive ? searchQuery.lowercased() : ""

        providers = allProviders.filter { provider in
            
            let matchesSearch = !isSearchActive ||
                (provider.name?.lowercased().contains(query) ?? false) ||
                (provider.specialty?.lowercased().contains(query) ?? false)

            let matchesCountry = activeCountryFilters.isEmpty ||
                activeCountryFilters.contains(provider.country ?? "")

            let matchesCity = activeCityFilters.isEmpty ||
                activeCityFilters.contains(provider.city ?? "")

            let matchesService = activeServiceFilters.isEmpty ||
                activeServiceFilters.contains(provider.specialty ?? "")

            return matchesSearch &&
                   matchesCountry &&
                   matchesCity &&
                   matchesService
        }

        guard !providers.isEmpty else {
            delegate?.showEmptyState()
            return
        }

        delegate?.reloadProviders()
    }
}
