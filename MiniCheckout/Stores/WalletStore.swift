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
    private let key = "wallet_balance"
    
    private(set) var balance: Decimal {
        didSet { persist() }
    }
    
    init(initialBalance: Decimal = 10_000) {
        if let stored = WalletStore.loadStoredBalance(key: key) {
            self.balance = stored
        } else {
            self.balance = initialBalance
        }
    }
    
    @MainActor
    func canAfford(_ amount: Decimal) -> Bool {
        return balance >= amount
    }
    
    @MainActor
    func deduct(_ amount: Decimal) {
        guard amount >= 0, balance >= amount else { return }
        balance -= amount
    }
    
    // MARK: - Persistence
    
    private func persist() {
        UserDefaults.standard.set(balance.description, forKey: key)
    }

    private static func loadStoredBalance(key: String) -> Decimal? {
        guard let keyString = UserDefaults.standard.string(forKey: key) else {return nil }
        return Decimal(string: keyString)
    }
}
