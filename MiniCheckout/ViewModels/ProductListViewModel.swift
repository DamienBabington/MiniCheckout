//
//  ProductListViewModel.swift
//  MiniCheckout
//
//  Created by Damien Babington on 12/18/25.
//

import Foundation
import Observation

@Observable
final class ProductListViewModel {
    enum State {
        case idle
        case loading
        case loaded([Product])
        case failed(String)
    }
    
    private let api: ProductAPI
    private(set) var state: State = .idle
    
    init(api: ProductAPI = LocalJSONProductAPI()) {
        self.api = api
    }
    
    @MainActor
    func loadProducts() async {
        state = .loading
        
        do {
            let products = try await api.fetchProducts()
            state = .loaded(products)
        } catch {
            state = .failed("Failed to load products. Please try again.")
        }
    }
}
