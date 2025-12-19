//
//  CheckoutView.swift
//  MiniCheckout
//
//  Created by Damien Babington on 12/18/25.
//

import SwiftUI

struct CheckoutView: View {
    @Environment(CartStore.self) private var cart
    @Environment(WalletStore.self) private var wallet
    @Environment(\.dismiss) private var dismiss
    
    @State private var viewModel = CheckoutViewModel()
    
    var body: some View {
        List {
            Section("Order Summary") {
                if cart.items.isEmpty {
                    Text("Your cart is empty.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(cart.items) { item in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("\(item.product.name)")
                                Text(item.product.price, format: .currency(code: "USD"))
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            
                            Spacer()
                            
                            Text("x \(item.quantity)")
                                .foregroundStyle(.secondary)
                                .padding(.trailing)
                        }
                    }
                }
            }
            
            Section {
                HStack {
                    Text("Total")
                    
                    Spacer()
                    
                    Text(cart.total, format: .currency(code: "USD"))
                        .fontWeight(.semibold)
                }
            }
            
            Section {
                checkoutStateRow
            }
        }
        .navigationTitle("Checkout")
        .onChange(of: viewModel.state) { _, newState in
            if case .success(let receipt) = newState {
                wallet.deduct(receipt.total)
                cart.clear()
            }
        }
    }
    
    @ViewBuilder
    private var checkoutStateRow: some View {
        switch viewModel.state {
        case .ready:
            Button {
                guard let request = makeRequest() else { return }
                Task { await viewModel.pay(with: request) }
            } label: {
                Text("Pay \(cart.total, format: .currency(code: "USD"))")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(cart.items.isEmpty || !wallet.canAfford(cart.total))
            
            if !wallet.canAfford(cart.total) {
                Text("Insufficient wallet balance.")
                    .font(.caption)
                    .foregroundStyle(.red)                    
            }
            
        case .processing:
            HStack(spacing: 12) {
                ProgressView()
                Text("Processing payment...")
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
        case .failed(let message):
            VStack(alignment: .leading, spacing: 12) {
                Text(message)
                    .foregroundStyle(.red)
                
                HStack {
                    Button("Retry") {
                        guard let request = makeRequest() else { return }
                        Task { await viewModel.pay(with: request) }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(cart.items.isEmpty)
                    
                    Button("Cancel") {
                        viewModel.reset()
                    }
                    .buttonStyle(.bordered)
                }
            }
            
        case .success(let receipt):
            VStack(alignment: .leading, spacing: 12) {
                Text("Payment Confirmed")
                    .font(.headline)
                
                Text("Receipt: \(receipt.receiptID.uuidString.prefix(8))")
                    .foregroundStyle(.secondary)
                
                Text("Total: \(receipt.total, format: .currency(code: "USD"))")
                
                Button("Done") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
    
    private func makeRequest() -> CheckoutRequest? {
        guard !cart.items.isEmpty else { return nil }
        
        let items = cart.items.map {
            CheckoutRequest.LineItem(
                productID: $0.product.id,
                quantity: $0.quantity,
                unitPrice: $0.product.price
            )
        }
        return CheckoutRequest(items: items, total: cart.total)
    }
}

#Preview {
    CheckoutView()
        .environment(CartStore())
        .environment(WalletStore())
}
