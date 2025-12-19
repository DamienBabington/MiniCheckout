//
//  MockCheckoutAPI.swift
//  MiniCheckout
//
//  Created by Damien Babington on 12/19/25.
//

import Foundation
@testable import MiniCheckout

struct MockCheckoutAPI: CheckoutAPI {
    let result: Result<CheckoutReceipt, Error>
    
    func checkout(_ request: CheckoutRequest) async throws -> CheckoutReceipt {
        try result.get()
    }
}
