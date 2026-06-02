//
//  MockDataService.swift
//  LokaldeCaseStudy
//
//  Created by Mehmet Biçici on 1.06.2026.
//

import Foundation

protocol ProviderServiceProtocol {
    func fetchProviders(completion: @escaping (Result<[ProviderDTO], Error>) -> Void)
}

final class MockDataService: ProviderServiceProtocol {
    
    enum ServiceError: Error {
        case fileNotFound
        case decodingError(Error)
    }
    
    func fetchProviders(completion: @escaping (Result<[ProviderDTO], Error>) -> Void) {
        
        guard let url = Bundle.main.url(forResource: "mock_providers", withExtension: "json") else {
            completion(.failure(ServiceError.fileNotFound))
            return
        }
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
            do {
                let data = try Data(contentsOf: url)
                
                let decoder = JSONDecoder()
                let response = try decoder.decode(ProviderResponse.self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(response.providers ?? []))
                }
                
            } catch {
                print("JSON Error: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(ServiceError.decodingError(error)))
                }
            }
        }
    }
}
