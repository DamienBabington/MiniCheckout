//
//  ProductAPI.swift
//  MiniCheckout
//
//  Created by Damien Babington on 12/18/25.
//

import Foundation

protocol ProductAPI {
    func fetchProducts() async throws -> [Product]
}
