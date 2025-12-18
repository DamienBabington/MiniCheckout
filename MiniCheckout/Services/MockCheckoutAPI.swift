//
//  MockCheckoutAPI.swift
//  MiniCheckout
//
//  Created by Damien Babington on 12/18/25.
//

import Foundation

final class MockCheckoutAPI: CheckoutAPI {
    
    func checkout(_ request: CheckoutRequest) async throws -> CheckoutReceipt {
        // Random delay between 1-2 seconds
        let delay = UInt64.random(in: 1_000_000_000...2_000_000_000)
        try await Task.sleep(nanoseconds: delay)
        
        // Random success/failure
        let roll = Int.random(in: 1...100)
                
        if roll <= 50 {
            // Success (50%)
            return CheckoutReceipt(receiptID: UUID(), total: request.total, timestampe: Date())
        } else if roll <= 80 {
            // Payment declined (30%)
            throw CheckoutError.paymentDeclined
        } else {
            // Network failure (20%)
            throw CheckoutError.networkFailure
        }
    }
}
