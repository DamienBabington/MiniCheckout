//
//  CartStore.swift
//  MiniCheckout
//
//  Created by Damien Babington on 12/18/25.
//

import Foundation
import Observation

@MainActor
@Observable
final class CartStore {
    private(set) var items: [CartItem] = []
    
    func add(_ product: Product) {
        // Increment if product is already in the cart
        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            items[index].quantity += 1
        } else {
            // Add product to cart
            items.append(CartItem(product: product, quantity: 1))
        }
    }
    
    func removeOne(_ product: Product) {
        // Make sure product is actually in the cart
        guard let index = items.firstIndex(where: { $0.product.id == product.id }) else { return }
        
        // Decrement or remove from cart
        if items[index].quantity > 1 {
            items[index].quantity -= 1
        } else {
            items.remove(at: index)
        }
    }
    
    func setQuantity(_ quantity: Int, for product: Product) {
        guard quantity >= 0 else { return }
        
        if quantity == 0 {
            items.removeAll { $0.product.id == product.id }
            return
        }
        
        // Upsert item quantity
        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            items[index].quantity = quantity
        } else {
            items.append(CartItem(product: product, quantity: quantity))
        }
    }
    
    func clear() {
        items.removeAll()
    }
    
    var itemCount: Int {
        // Sum quantity of all items
        items.reduce(0) { $0 + $1.quantity }
    }
    
    var total: Decimal {
        // Sum of each product's subtotal
        items.reduce(0) { $0 + ($1.product.price * Decimal($1.quantity)) }
    }
}
