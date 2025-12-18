//
//  Product.swift
//  MiniCheckout
//
//  Created by Damien Babington on 12/18/25.
//

import Foundation

struct Product: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let price: Decimal
    
    init(id: UUID = UUID(), name: String, price: Decimal) {
        self.id = id
        self.name = name
        self.price = price
    }
}
