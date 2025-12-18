//
//  CartStore.swift
//  MiniCheckout
//
//  Created by Damien Babington on 12/18/25.
//

import Foundation
import Observation

@Observable
final class CartStore {
    
    private(set) var items: [CartItem] = [] {
        didSet { persist() }
    }
    
    private let persistence: CartPersistence
    
    init(persistence: CartPersistence = UserDefaultsCartPersistence()) {
        self.persistence = persistence
    }
    
    // MARK: - Cart Actions
    
    @MainActor
    func add(_ product: Product) {
        // Increment if product is already in the cart
        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            items[index].quantity += 1
        } else {
            // Add product to cart
            items.append(CartItem(product: product, quantity: 1))
        }
    }
    
    @MainActor
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
    
    @MainActor
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
    
    @MainActor
    func clear() {
        items.removeAll()
    }
    
    // MARK: - Computed Properties
    
    var itemCount: Int {
        // Sum quantity of all items
        items.reduce(0) { $0 + $1.quantity }
    }
    
    var total: Decimal {
        // Sum of each product's subtotal
        items.reduce(0) { $0 + ($1.product.price * Decimal($1.quantity)) }
    }
    
    // MARK: - Persistence
    
    @MainActor
    func restore(using products: [Product]) {
        let storedItems = persistence.load()
        
        items = storedItems.compactMap { stored in
            guard let product = products.first(where: { $0.id == stored.productID }) else {
                return nil
            }
            return CartItem(product: product, quantity: stored.quantity)
        }
    }
    
    private func persist() {
        let stored = items.map {
            StoredCartItem(productID: $0.product.id, quantity: $0.quantity)
        }
        persistence.save(stored)
    }
}
