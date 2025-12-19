//
//  CartItem.swift
//  MiniCheckout
//
//  Created by Damien Babington on 12/18/25.
//

import Foundation

struct CartItem: Identifiable, Hashable {
    var id: UUID { product.id }
    let product: Product
    var quantity: Int
}
