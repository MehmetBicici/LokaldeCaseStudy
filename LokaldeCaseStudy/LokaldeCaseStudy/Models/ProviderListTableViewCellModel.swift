//
//  ProviderListTableViewCellModel.swift
//  LokaldeCaseStudy
//
//  Created by Mehmet Biçici on 2.06.2026.
//

import Foundation

struct ProviderListTableViewCellModel {
    let id: String?
    let name: String?
    let imageURL: String?
    let specialty: String?
    let city: String?
    let rating: Double?
    
    var subtitle: String {
        return [specialty, city]
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .joined(separator: " • ")
    }
    
    var ratingText: String {
        guard let rating = rating else { return "-" }
        return String(format: "%.1f", rating)
    }
}
