//
//  CartView.swift
//  MiniCheckout
//
//  Created by Damien Babington on 12/18/25.
//

import SwiftUI

struct CartView: View {
    @Environment(CartStore.self) private var cart
    @State private var showCheckout = false
    
    var body: some View {
        List {
            if cart.items.isEmpty {
                ContentUnavailableView("Your cart is empty",
                                       image: "bag",
                                       description: Text("Add products from the Products tab"))
            } else {
                Section("Items") {
                    ForEach(cart.items) { item in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.product.name)
                                
                                Text(item.product.price, format: .currency(code: "USD"))
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            
                            Spacer()
                            
                            Stepper(
                                value: Binding(
                                    get: { item.quantity },
                                    set: { cart.setQuantity($0, for: item.product) }
                                ),
                                in: 0...20
                            ) {
                                Text("\(item.quantity)")
                                    .monospacedDigit()
                                    .frame(width: 30, alignment: .trailing)
                            }
                            .labelsHidden()
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
                    
                    Button("Go to Checkout") {
                        showCheckout = true
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(cart.items.isEmpty)
                    
                    Button("Clear Cart", role: .destructive) {
                        cart.clear()
                    }
                }
            }
        }
        .navigationTitle("Cart")
        .navigationDestination(isPresented: $showCheckout) {
            CheckoutView()
        }
    }
}

#Preview {
    CartView()
        .environment(CartStore())
}
