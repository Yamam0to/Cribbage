//
//  ContentView.swift
//  IOSremote
//
//  Created by Ajay Yamamoto on 2026-04-12.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var connection: Connection
    @State var hand: [Card] = []
    var body: some View {
        HStack {
            Button("Send Test Ping") {
                connection.sendTestMessage()
            }
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
