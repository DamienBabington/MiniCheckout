//
//  UserDefaultsCartPersistence.swift
//  MiniCheckout
//
//  Created by Damien Babington on 12/18/25.
//

import Foundation

final class UserDefaultsCartPersistence: CartPersistence {
    private let key  = "cart_items"
    
    func load() -> [StoredCartItem] {
        guard
            let data = UserDefaults.standard.data(forKey: key),
            let items = try? JSONDecoder().decode([StoredCartItem].self, from: data)
        else {
            return []
        }
        return items
    }
    
    func save(_ items: [StoredCartItem]) {
        guard let data = try? JSONEncoder().encode(items) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
}
