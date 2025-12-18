//
//  CartView.swift
//  MiniCheckout
//
//  Created by Damien Babington on 12/18/25.
//

import SwiftUI

struct CartView: View {
    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    CartView()
        .environment(CartStore())
}
