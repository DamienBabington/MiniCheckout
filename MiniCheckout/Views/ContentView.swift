//
//  ContentView.swift
//  MiniCheckout
//
//  Created by Damien Babington on 12/18/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(CartStore.self) private var cart
    
    var body: some View {
        TabView {
            NavigationStack {
                ProductListView()
            }
            .tabItem {
                Label("Products", systemImage: "cart")
            }
            
            NavigationStack {
                CartView()
            }
            .tabItem {
                Label("Cart", systemImage: "bag")
            }
            .badge(cart.itemCount)
        }
    }
}

#Preview {
    ContentView()
        .environment(CartStore())
}
