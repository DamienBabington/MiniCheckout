//
//  MiniCheckoutApp.swift
//  MiniCheckout
//
//  Created by Damien Babington on 12/18/25.
//

import SwiftUI

@main
struct MiniCheckoutApp: App {
    @State private var cartStore = CartStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(cartStore)
        }
    }
}
