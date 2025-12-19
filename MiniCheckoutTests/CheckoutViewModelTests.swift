//
//  CheckoutViewModelTests.swift
//  MiniCheckout
//
//  Created by Damien Babington on 12/19/25.
//

import XCTest
@testable import MiniCheckout

@MainActor
final class CheckoutViewModelTests: XCTestCase {
    
    func testCheckoutSuccessTransitionsToSuccessState() async {
        // Given
        let receipt = CheckoutReceipt(
            receiptID: UUID(),
            total: 1500,
            timestampe: Date())
        
        let api = MockCheckoutAPI(result: .success(receipt))
        let viewModel = CheckoutViewModel(api: api)
        
        let request = CheckoutRequest(
            items: [
                .init(productID: UUID(), quantity: 2, unitPrice: 750)
            ],
            total: 1500
        )
        
        // When
        await viewModel.pay(with: request)
        
        // Then
        switch viewModel.state {
        case .success(let receivedReceipt):
            XCTAssertEqual(receivedReceipt.total, receipt.total)
        default:
            XCTFail("Expected success state, got \(viewModel.state).")
        }
    }
}

