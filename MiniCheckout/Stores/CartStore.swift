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
        
    }
    
    func remove(_ product: Product) {
        
    }
    
    func setQuantity(_ quantity: Int, for product: Product) {
        
    }
    
    func clear() {
        
    }
    
    var itemCount: Int {
        return 0
    }
    
    var total: Decimal {
        return 0.0
    }
}
