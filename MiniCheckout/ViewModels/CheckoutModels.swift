//
//  CheckoutModels.swift
//  MiniCheckout
//
//  Created by Damien Babington on 12/18/25.
//

import Foundation

struct CheckoutRequest: Codable, Equatable {
    struct LineItem: Codable, Equatable {
        let productID: UUID
        let quantity: Int
        let unitPrice: Int
    }
    
    let items: [LineItem]
    let total: Int
}

struct CheckoutReceipt: Codable, Equatable {
    let receiptID: UUID
    let total: Int
    let timestampe: Date
}
