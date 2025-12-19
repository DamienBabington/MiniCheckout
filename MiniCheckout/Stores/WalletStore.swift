//
//  WalletStore.swift
//  MiniCheckout
//
//  Created by Damien Babington on 12/19/25.
//

import Foundation
import Observation

@Observable
final class WalletStore {
    private let key: String
    private let defaults: UserDefaults
    
    private(set) var balance: Int {
        didSet { persist() }
    }
    
    init(
        initialBalance: Int = 10_000,
        defaults: UserDefaults = .standard,
        key: String = "wallet_balance"
    ) {
        self.defaults = defaults
        self.key = key
        self.balance = defaults.object(forKey: key) as? Int ?? initialBalance
    }
    
    @MainActor
    func canAfford(_ amount: Int) -> Bool {
        return balance >= amount
    }
    
    @MainActor
    func deduct(_ amount: Int) {
        guard amount >= 0, balance >= amount else { return }
        balance -= amount
    }
    
    // MARK: - Persistence
    
    private func persist() {
        defaults.set(balance, forKey: key)
    }
}
