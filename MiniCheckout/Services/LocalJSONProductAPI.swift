//
//  LocalJSONProductAPI.swift
//  MiniCheckout
//
//  Created by Damien Babington on 12/18/25.
//

import Foundation

enum ProductAPIError: Error {
    case fileNotFound
    case decodingError
}

final class LocalJSONProductAPI: ProductAPI {
    func fetchProducts() async throws -> [Product] {
        // Simulate latency
        try await Task.sleep(nanoseconds: 800_000_000)
        
        guard let url = Bundle.main.url(forResource: "products", withExtension: "json") else {
            throw ProductAPIError.fileNotFound
        }
        
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode([Product].self, from: data)
        } catch {
            throw ProductAPIError.decodingError
        }
    }
}
