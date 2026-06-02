//
//  FiltersViewModel.swift
//  LokaldeCaseStudy
//
//  Created by Mehmet Biçici on 2.06.2026.
//

import Foundation

enum FilterType {
    case country
    case city
    case services
    
    var title: String {
        switch self {
        case .country: return String(localized: "select_country", defaultValue: "Country")
        case .city: return String(localized: "select_city", defaultValue: "City")
        case .services: return String(localized: "select_services", defaultValue: "Services")
        }
    }
}

protocol FiltersViewModelDelegate: AnyObject {
    func reloadFilters()
    func dismissAndApplyFilters(selectedOptions: [FilterOptionModel], filterType: FilterType)
}

protocol FiltersViewModelInterface {
    var pageTitle: String { get }
    var options: [FilterOptionModel] { get }
    
    func setDelegate(_ delegate: FiltersViewModelDelegate)
    func viewDidLoad()
    func toggleSelection(at index: Int)
    func applyFilters()
    func clearFilters()
}

final class FiltersViewModel: FiltersViewModelInterface {
    
    private weak var delegate: FiltersViewModelDelegate?
    private let filterType: FilterType
    private let availableOptions: [String]
    
    private(set) var options: [FilterOptionModel] = []
    private let previouslySelectedFilters: [String]
    
    var pageTitle: String {
        return filterType.title
    }

    init(filterType: FilterType, activeSelection: [String], availableOptions: [String]) {
        self.filterType = filterType
        self.previouslySelectedFilters = activeSelection
        self.availableOptions = availableOptions
    }
    
    func setDelegate(_ delegate: FiltersViewModelDelegate) {
        self.delegate = delegate
    }
    
    func viewDidLoad() {
        loadFilteredOptions()
    }
    
    func toggleSelection(at index: Int) {
        options[index].isSelected.toggle()
        delegate?.reloadFilters()
    }
    
    func applyFilters() {
        let selectedOptions = options.filter { $0.isSelected }
        delegate?.dismissAndApplyFilters(selectedOptions: selectedOptions, filterType: filterType)
    }
    
    func clearFilters() {
        for i in 0..<options.count {
            options[i].isSelected = false
        }
        delegate?.reloadFilters()
    }
}

private extension FiltersViewModel {
    func loadFilteredOptions() {
        var generatedOptions = availableOptions.enumerated().map { (index, title) in
            let isSelected = previouslySelectedFilters.contains(title)
            return FilterOptionModel(id: "\(filterType)_\(index)", title: title, isSelected: isSelected)
        }
        
        generatedOptions.sort { first, second in
            if first.isSelected == second.isSelected {
                return first.title < second.title
            }
            return first.isSelected && !second.isSelected
        }
        
        self.options = generatedOptions
        delegate?.reloadFilters()
    }
}
