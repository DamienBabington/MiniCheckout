//
//  ProductListView.swift
//  MiniCheckout
//
//  Created by Damien Babington on 12/18/25.
//

import SwiftUI

struct ProductListView: View {
    @Environment(CartStore.self) private var cart
    @State private var viewModel = ProductListViewModel()
    
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
                                    Text(product.price, format: .currency(code: "USD"))
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                
                                Spacer()
                                
                                Button("Add") {
                                    cart.add(product)
                                }
                                .buttonStyle(.borderedProminent)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Products")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Text("Cart: \(cart.itemCount)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    ProductListView()
        .environment(CartStore())
}
