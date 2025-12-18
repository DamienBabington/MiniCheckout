//
//  CheckoutView.swift
//  MiniCheckout
//
//  Created by Damien Babington on 12/18/25.
//

import SwiftUI

struct CheckoutView: View {
    @Environment(CartStore.self) private var cart
    
    var body: some View {
        List {
            Section("Order Summary") {
                ForEach(cart.items) { item in
                    Text("\(item.product.name))")
                    Spacer()
                    Text("x\(item.quantity)")
                        .foregroundStyle(.secondary)
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
        }
        .navigationTitle("Checkout")
        .safeAreaInset(edge: .bottom) {
            Button(action: { /* Pay */ }) {
                Text("Pay \(cart.total, format: .currency(code: "USD"))")
                    .frame(maxWidth: .infinity)
                    .buttonStyle(.borderedProminent)
                    .padding()
                    .background(.ultraThinMaterial)
                    .disabled(cart.items.isEmpty)
            }
        }
    }
}

#Preview {
    CheckoutView()
        .environment(CartStore())
}
