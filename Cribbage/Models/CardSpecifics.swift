//
//  CardSpecifics.swift
//  Cribbage
//
//  Created by Ajay Yamamoto on 2026-04-12.
//
import SwiftUI

enum Suit: String, CaseIterable, Codable {
    case spades, hearts, diamonds, clubs
}

enum Rank: Int, CaseIterable, Codable {
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

struct Card: Hashable, Identifiable, Codable {
    var id = UUID()
    let suit: Suit
    let rank: Rank
}

struct cardNotButton: View {
    let height: CGFloat
    let card: Card
    var body: some View {
        Image("\(card.rank)-\(card.suit)")
            .resizable()
            .scaledToFit()
            .frame(height: height)
    }
}
