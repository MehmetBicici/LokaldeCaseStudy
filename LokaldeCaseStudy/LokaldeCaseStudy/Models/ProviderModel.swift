//
//  ProviderModel.swift
//  LokaldeCaseStudy
//
//  Created by Mehmet Biçici on 1.06.2026.
//

import Foundation

struct ProviderResponse: Decodable {
    let providers: [ProviderDTO]?
}

struct ProviderDTO: Decodable {
    let id: String?
    let name: String?
    let profileImageUrl: String?
    let specialty: String?
    let country: String?
    let city: String?
    let rating: Double?
    let contactInfo: ContactInfoDTO?
    let bio: String?
}

struct ContactInfoDTO: Decodable {
    let phone: String?
    let email: String?
    let address: String?
}
