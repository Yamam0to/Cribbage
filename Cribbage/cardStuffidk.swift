//
//  cardStuffidk.swift
//  Cribbage
//
//  Created by Ajay Yamamoto on 2026-04-05.
//

import Foundation
import SwiftUI

enum Suit: String, CaseIterable {
    case spades, hearts, diamonds, clubs
}

enum Rank: Int, CaseIterable {
    case two = 2
    case three = 3
    case four = 4
    case five = 5
    case six = 6
    case seven = 7
    case eight = 8
    case nine = 9
    case ten = 10
    case jack = 11
    case queen = 12
    case king = 13
    case ace = 1
    
    // if needed, instead of using .rawValue, use .value and make kings, queens, and jacks worth 10 t00
    var value: Int {
        switch self {
            case .jack, .queen, .king:
                return 10
            default:
                return self.rawValue
        }
    }
}

struct Card: Hashable, Identifiable {
    let id = UUID()
    let suit: Suit
    let rank: Rank
}

struct Deck {
    var deckOfCards: [Card] = []
    @Binding var playerHand: [Card]
    @Binding var botHand: [Card]
    @Binding var cut: Card
    
    mutating func dealCards() {
        //creating the deck
        for suit in Suit.allCases {
            for rank in Rank.allCases {
                deckOfCards.append(Card(suit: suit, rank: rank))
            }
        }
        
        //creating the hands
        for _ in 1...6 {
            var randNum = Int.random(in: 0..<deckOfCards.count)
            playerHand.append(deckOfCards[randNum])
            deckOfCards.remove(at: randNum)
            
            randNum = Int.random(in: 0..<deckOfCards.count)
            botHand.append(deckOfCards[randNum])
            deckOfCards.remove(at: randNum)
        }
        let randNum = Int.random(in: 0..<deckOfCards.count)
        cut = deckOfCards[randNum]
        deckOfCards.remove(at: randNum)
        
        
        //return [playerHand, botHand, cut]
    }
}

struct CardButton: View {
    let card: Card
    @ObservedObject var game: GameState
    @State private var isHovered = false
    
    var body: some View {
        Button(action: {
            game.cardClicked(card: card)
        }) {
            Image("\(card.rank)-\(card.suit)")
                .resizable()
                .scaledToFit()
                .frame(height: 200)
        }
        .buttonStyle(PlainButtonStyle())
        .offset(y: isHovered ? -20 : 0)
        .onHover { hovering in
                   withAnimation(.spring(response: 0.3)) {
                       isHovered = hovering
                   }
               }
    }
}

struct cardNotButton: View {
    let card: Card
    var body: some View {
        Image("\(card.rank)-\(card.suit)")
            .resizable()
            .scaledToFit()
            .frame(height: 75)
    }
}

struct SlidingText: View {
    let title: String
    let isMoving: Bool
    var body: some View {
        Text(title)
            .font(.system(size: 80))
            .foregroundStyle(Color.black)
            .fontDesign(.rounded)
            .underline(true, color: Color.yellow)
            .offset(x: isMoving ? -850 : 850)
            .animation(.linear(duration: 2.8), value: isMoving)
    }
}
