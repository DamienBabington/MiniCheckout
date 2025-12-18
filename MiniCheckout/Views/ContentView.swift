//
//  ContentView.swift
//  MiniCheckout
//
//  Created by Damien Babington on 12/18/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationStack {
                ProductListView()
            }
            .tabItem { Label("Products", systemImage: "cart") }
            
            NavigationStack {
                CartView()
            }
            .tabItem { Label("Cart", systemImage: "bag")}
        }
    }
}

#Preview {
    ContentView()
        .environment(CartStore())
}
