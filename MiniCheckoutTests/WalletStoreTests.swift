//
//  WalletStoreTests.swift
//  MiniCheckoutTests
//
//  Created by Damien Babington on 12/19/25.
//

import XCTest
@testable import MiniCheckout

final class WalletStoreTests: XCTestCase {

    private var defaults: UserDefaults!

    override func setUp() {
        super.setUp()
        defaults = UserDefaults(suiteName: "WalletStoreTests")!
        defaults.removePersistentDomain(forName: "WalletStoreTests")
    }

    func testWalletDeductReducesBalance() async {
        // Given
        let wallet = await MainActor.run {
            WalletStore(
                initialBalance: 3000,
                defaults: defaults,
                key: "wallet_balance"
            )
        }

        await MainActor.run {
            // When
            wallet.deduct(1200)
            
            // Then
            XCTAssertEqual(wallet.balance, 1800)
        }
    }
    
    func testWalletCannotBeNegative() async {
        // Given
        let wallet = await MainActor.run {
            WalletStore(
                initialBalance: 1000,
                defaults: defaults,
                key: "wallet_balance"
            )
        }

        await MainActor.run {
            // When
            wallet.deduct(2000)
            
            // Then
            XCTAssertEqual(wallet.balance, 1000)
        }
    }
}
