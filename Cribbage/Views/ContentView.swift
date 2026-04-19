//
//  ContentView.swift
//  Cribbage
//
//  Created by Ajay Yamamoto on 2026-04-05.
//

import SwiftUI

struct ContentView: View {
    @StateObject var game = GameState()
    @EnvironmentObject var connection: Connection
    
    @State private var startButton = true
    @State private var showSlide = false
    
    var body: some View {
        ZStack {
            Color.table
            VStack {
                HStack {
                    Spacer()
                    ForEach(game.botHand, id: \.self) { _ in
                        Image("back")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    }
                    Spacer()
                }
                .frame(height: 250)
                .background(Color.cardSurface)
                
                Spacer()
                
                HStack {
                    
                    Spacer()
                    
                    // Creating the card images
                    ForEach(game.playerHand, id: \.self) { card in
                        CardButton(card: card, game: game)
                    }
                    Spacer()
                }
                .frame(height: 250)
                .background(Color.cardSurface)
                
            }
            // show played cards
            VStack {
                ZStack {
                    ForEach(game.playedCards, id: \.self) { card in
                        Image("\(card.rank)-\(card.suit)")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    }
                }
                HStack {
                    ForEach(Array(game.playedCards.enumerated()), id: \.element.id) { index, card in
                        cardNotButton(height: 75, card: card)
                            .offset(x: CGFloat(index) * 10)
                    }
                }
                .padding(.trailing, CGFloat((game.playedCards.count - 1) * 10))
            }
            .position(x: 600, y: 450)
            
            ForEach(game.discardPile.indices, id: \.self) { card in
                Image("back")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .position(x: 60, y: 580)
                    .offset(x: CGFloat(card) * 15.0)
            }
            
            //Deal button / start button
            if startButton {
                Button(action: {
                    game.dealCards()
                    game.discardRound = 0
                    showSlide.toggle()
                    startButton = false
                }) {
                    Text("Start")
                        .frame(width: 100)
                }
                .buttonStyle(.glassProminent)
            }
            
            //cut
            if game.discardRound == 3 {
                VStack {
                    Image("\(game.cut.rank)-\(game.cut.suit)")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                    Text("Cut")
                        .foregroundStyle(Color.black)
                        .fontDesign(.rounded)
                        .bold()
                }
                .position(x: 1100, y: 450)
            }
            
            //Sliding text
            SlidingText(title: game.playerStarts ? "Player's Crib" : "Bot's Crib", isMoving: showSlide)
            
            //Go
            SlidingText(title: "Go", isMoving: game.goTrue)
            
            //Show points
            VStack {
                Text("Player: \(game.playerPoints)")
                    .fontDesign(.rounded)
                    .font(.title3)
                Text("Bot: \(game.botPoints)")
                    .fontDesign(.rounded)
                    .font(.title3)
            }
            .position(x: 1100, y: 610)
            
            //overlay
            if let type = game.pointCountingTime {
                switch type {
                case .player :
                    PointOverlay(title: "Your Hand (+cut)", cards: game.afterPlayerHand, cut: game.cut, isCrib: false) {game.pointCountingTime = .bot}
                case .bot :
                    PointOverlay(title: "Bot's Hand (+cut)", cards: game.afterBotHand, cut: game.cut, isCrib: false) {game.pointCountingTime = .crib}
                case .crib :
                    PointOverlay(title: "Crib (+cut)", cards: game.crib, cut: game.cut, isCrib: true) {game.reset()}
                }
            }
            
        }
    }
}

#Preview {
    ContentView()
}
