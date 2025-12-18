//
//  ProductListView.swift
//  MiniCheckout
//
//  Created by Damien Babington on 12/18/25.
//

import SwiftUI

struct ProductListView: View {
    @Environment(CartStore.self) private var cart
    
    // Placeholder data
    private let products: [Product] = [
        Product(name: "Milk", price: 2.49),
        Product(name: "Eggs", price: 3.99),
        Product(name: "Bread", price: 2.19),
        Product(name: "Chicken", price: 4.50)
    ]
    
    var body: some View {
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
