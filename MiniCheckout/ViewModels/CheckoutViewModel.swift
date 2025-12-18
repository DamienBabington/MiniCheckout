//
//  CheckoutViewModel.swift
//  MiniCheckout
//
//  Created by Damien Babington on 12/18/25.
//

import Foundation
import Observation

@Observable
final class CheckoutViewModel {
    enum State: Equatable {
        case ready
        case processing
        case success(CheckoutReceipt)
        case failed(String)
    }
    
    private let api: CheckoutAPI
    private(set) var state: State = .ready
    
    init(api: CheckoutAPI = MockCheckoutAPI()) {
        self.api = api
    }
    
    var isProcessing: Bool {
        if case .processing = state { return true }
        return false
    }
    
    @MainActor
    func pay(with request: CheckoutRequest) async {
        guard !isProcessing else { return }
        
        state = .processing
        do {
            let receipt = try await api.checkout(request)
            state = .success(receipt)
        } catch let error as CheckoutError {
            switch error {
            case .paymentDeclined:
                state = .failed("Payment was declined. Please try again.")
            case .networkFailure:
                state = .failed("Network error. Please try again.")
            }
        } catch {
            state = .failed("Something went wrong. Please try again.")
        }
    }
    
    @MainActor
    func reset() {
        state = .ready
    }
}
