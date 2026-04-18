//
//  ValidMoves.swift
//  Cribbage
//
//  Created by Ajay Yamamoto on 2026-04-12.
//
struct ValidMoves {
    let cards: [Card]
    let pegCount: Int
    
    func canMove() -> Bool {
        return self.cards.contains(where: { $0.rank.value + pegCount <= 31 })
    }
}
