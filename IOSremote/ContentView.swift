//
//  ContentView.swift
//  IOSremote
//
//  Created by Ajay Yamamoto on 2026-04-12.
//

import SwiftUI

struct ContentView: View {
    @StateObject var network = Connection()
    @State var hand: [Card] = []
    var body: some View {
        HStack {
            Rectangle()
                .fill(network.connectedPeers.isEmpty ? Color.red : Color.purple)
            ForEach(hand) {card in
                Button(action: {
                    print("\(card.rank) of \(card.suit)")
                }) {
                    cardNotButton(height: 200, card: card)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
