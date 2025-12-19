//
//  CheckoutAPI.swift
//  MiniCheckout
//
//  Created by Damien Babington on 12/18/25.
//

import Foundation

protocol CheckoutAPI {
    func checkout(_ request: CheckoutRequest) async throws -> CheckoutReceipt
}

enum CheckoutError: Error {
    case paymentDeclined
    case networkFailure
}
