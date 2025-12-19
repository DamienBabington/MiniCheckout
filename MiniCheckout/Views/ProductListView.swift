//
//  ProductListView.swift
//  MiniCheckout
//
//  Created by Damien Babington on 12/18/25.
//

import SwiftUI

struct ProductListView: View {
    @Environment(CartStore.self) private var cart
    @Environment(WalletStore.self) private var wallet
    
    @State private var viewModel = ProductListViewModel()
    @State private var quantities: [UUID: Int] = [:]
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .idle, .loading:
                ProgressView("Loading products...")
                    .task { await viewModel.loadProducts() }
            case .failed(let message):
                VStack(spacing: 12) {
                    Text(message)
                    Button("Retry") {
                        Task { await viewModel.loadProducts() }
                    }
                }
            case .loaded(let products):
                List {
                    Section {
                        ForEach(products) { product in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(product.name)
                                    Text(product.price, format: .currency(code: "JPY"))
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                
                                Spacer()
                                
                                Stepper("Quantity",
                                        value: Binding(
                                            get: { quantity(for: product) },
                                            set: { quantities[product.id] = max(1, $0) }
                                        ),
                                        in: 1...20
                                )
                                .labelsHidden()
                                
                                Text("\(quantity(for: product))")
                                    .padding()
                                
                                Button("Add") {
                                    let qty = quantity(for: product)
                                    cart.add(product, quantity: qty)
                                    quantities[product.id] = 1
                                }
                                .buttonStyle(.borderedProminent)
                            }
                        }
                    }
                }
                .onAppear {
                    cart.restore(using: products)
                }
            }
        }
        .navigationTitle("Products")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Text("Wallet: \(wallet.balance, format: .currency(code: "JPY"))")
                    .foregroundStyle(.secondary)
                    .monospacedDigit()
                    .padding()
            }
        }
    }
    
    private func quantity(for product: Product) -> Int {
        quantities[product.id] ?? 1
    }
}

#Preview {
    ProductListView()
        .environment(CartStore())
        .environment(WalletStore())
}
