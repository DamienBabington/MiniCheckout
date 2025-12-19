//
//  CartView.swift
//  MiniCheckout
//
//  Created by Damien Babington on 12/18/25.
//

import SwiftUI

struct CartView: View {
    @Environment(CartStore.self) private var cart
    @Environment(WalletStore.self) private var wallet
    
    @State private var showCheckout = false
    @State private var showClearConfirmation: Bool = false
    
    var body: some View {
        List {
            if cart.items.isEmpty {
                ContentUnavailableView("Your cart is empty",
                                       systemImage: "bag",
                                       description: Text("Add products from the Products tab"))
            } else {
                Section("Items") {
                    ForEach(cart.items) { item in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.product.name)
                                
                                Text(item.product.price, format: .currency(code: "JPY"))
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            
                            Spacer()
                            
                            VStack(spacing: 4) {
                                Text(
                                    (item.product.price * item.quantity),
                                    format: .currency(code: "JPY")
                                )
                                .fontWeight(.semibold)
                                
                                Text("Quantity: \(item.quantity)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .monospacedDigit()
                                
                                Stepper(
                                    value: Binding(
                                        get: { item.quantity },
                                        set: { cart.setQuantity($0, for: item.product) }
                                    ),
                                    in: 0...20
                                ) {
                                    EmptyView()
                                }
                                .labelsHidden()
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Cart")
        .navigationDestination(isPresented: $showCheckout) {
            CheckoutView()
        }
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 10) {
                HStack {
                    Text("Total")
                        .font(.title)
                    Text(cart.total, format: .currency(code: "JPY"))
                        .font(.title)
                        .fontWeight(.semibold)
                }
                
                Button() {
                    showCheckout = true
                } label: {
                    Text("Checkout")
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
                .disabled(cart.items.isEmpty)
                
                Button("Clear Cart", role: .destructive) {
                    showClearConfirmation = true
                }
                .frame(maxWidth: .infinity)
                .disabled(cart.items.isEmpty)
            }
            .padding()
            .background(.ultraThinMaterial)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Text("Wallet: \(wallet.balance, format: .currency(code: "JPY"))")
                    .foregroundStyle(.secondary)
                    .monospacedDigit()
                    .padding()
            }
        }
        .alert("Clear Cart", isPresented: $showClearConfirmation) {
            Button("Clear Cart", role: .destructive) {
                cart.clear()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This will remove all items from your cart.")
        }
    }
}

#Preview {
    CartView()
        .environment(CartStore())
}
