//
//  CartPersistence.swift
//  MiniCheckout
//
//  Created by Damien Babington on 12/18/25.
//

import Foundation

protocol CartPersistence {
    func load() -> [StoredCartItem]
    func save(_ items: [StoredCartItem])
}
