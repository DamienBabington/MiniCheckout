//
//  StoredCartItem.swift
//  MiniCheckout
//
//  Created by Damien Babington on 12/18/25.
//

import Foundation

struct StoredCartItem: Codable {
    let productID: UUID
    let quantity: Int
}
