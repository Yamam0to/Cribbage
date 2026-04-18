//
//  pegging.swift
//  Cribbage
//
//  Created by Ajay Yamamoto on 2026-04-08.
//
import Foundation
import SwiftUI
import Combine

//point summary
enum pointSummaryType {
    case player
    case bot
    case crib
}

class GameState: ObservableObject {
    @Published var playerStarts: Bool = Bool.random()
    @Published var playerHand: [Card] = []
    @Published var botHand: [Card] = []
    @Published var cut: Card = Card(suit: .clubs, rank: .two)
    
    @Published var afterPlayerHand: [Card] = []
    @Published var afterBotHand: [Card] = []
    @Published var crib: [Card] = []
    
    @Published var playerCanGo: Bool = true
    @Published var botCanGo: Bool = true
    @Published var goTrue: Bool = false
    
    @Published var playerTurn: Bool = false
    @Published var botTurn: Bool = false
    @Published var pegCount: Int = 0
    @Published var playedCards: [Card] = []
    
    @Published var discardPile: [Card] = []
    @Published var discardRound: Int = -1
    
    @Published var playerPoints: Int = 0
    @Published var botPoints: Int = 0
    
    @Published var pointCountingTime: pointSummaryType? = nil
    
    
    var isBotThinking = false
    
    func dealCards() {
        var deckOfCards: [Card] = []
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
    
    func cardClicked(card: Card) {
        if discardRound >= 0 && discardRound < 2 {
            discard(card: card)
        } else if playerTurn {
            playerMove(card: card)
        } else if pointCountingTime != nil {
            //
        }
    }
    
    func discard(card: Card) {
        discardPile.append(card)
        playerHand.removeAll(where: {$0 == card})
        discardRound += 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.discardPile.append(self.botHand[self.botHand.count - 1])
            self.botHand.removeLast()
            if self.discardRound == 2 {
                self.afterBotHand = self.botHand + [self.cut]
                self.crib = self.discardPile + [self.cut]
            }
        }
        if discardRound == 2 {
            //finalizing hands for end counting
            afterPlayerHand = playerHand + [cut]
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.discardRound = 3
                if self.cut.rank == .jack {
                    if self.playerStarts {
                        self.playerPoints += 2
                    } else {
                        self.botPoints += 2
                    }
                }
            }
            if playerStarts {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.playedCards.append(self.botHand[0])
                    self.pegCount += self.botHand[0].rank.value
                    self.botHand.remove(at: 0)
                    self.playerTurn = true
                }
            } else {
                playerTurn = true
            }
        }
    }
    
    func executeMove(card: Card, isPlayer: Bool) {
        playedCards.append(card)
        pegCount += card.rank.value
        if isPlayer {
            playerHand.removeAll { $0 == card }
            playerPoints += PeggingPoints().peggingPoints(cards: playedCards, count: pegCount)
        } else {
            botHand.removeAll { $0 == card }
            botPoints += PeggingPoints().peggingPoints(cards: playedCards, count: pegCount)
        }
    }
    
    func playerMove(card: Card) {
        if !isBotThinking {
            if card.rank.value + pegCount <= 31 {
                executeMove(card: card, isPlayer: true)
                
                
                if pegCount == 31 || !ValidMoves(cards: playerHand, pegCount: pegCount).canMove() && !ValidMoves(cards: botHand, pegCount: pegCount).canMove() {
                    if pegCount < 31 {
                        playerPoints += 1
                    }
                    if playerHand.count == 0 && botHand.count == 0 {
                        pointCountingTime = .player
                    }
                    pegCount = 0
                    playedCards = []
                    botMove()
                } else {
                    if ValidMoves(cards: botHand, pegCount: pegCount).canMove() {
                        botMove()
                    } else {
                        if botHand.count > 0 {
                            goTrue = true
                        }
                    }
                }
            }
        }
    }
    
    func botMove() {
        if let cardToPlay = self.botHand.first(where: { $0.rank.value + self.pegCount <= 31 }) {
            isBotThinking = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.executeMove(card: cardToPlay, isPlayer: false)
                //reset?
                if self.pegCount == 31 || !ValidMoves(cards: self.playerHand, pegCount: self.pegCount).canMove() && !ValidMoves(cards: self.botHand, pegCount: self.pegCount).canMove() {
                    if self.pegCount < 31 {
                        self.botPoints += 1
                    }
                    if self.playerHand.count == 0 && self.botHand.count == 0 {
                        self.pointCountingTime = .player
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
                        self.pegCount = 0
                        self.playedCards = []
                    }
                }
                
                if !ValidMoves(cards: self.playerHand, pegCount: self.pegCount).canMove() && ValidMoves(cards: self.botHand, pegCount: self.pegCount).canMove() {
                    self.botMove()
                }
                self.isBotThinking = false
            }
            
        }
    }
    
    func reset() {
        playerPoints += FinalPoints(cards: afterPlayerHand).finalPoints(cut: cut, isCrib: false)
        botPoints += FinalPoints(cards: afterBotHand).finalPoints(cut: cut, isCrib: false)
        if playerStarts {
            playerPoints += FinalPoints(cards: crib).finalPoints(cut: cut, isCrib: true)
        } else {
            botPoints += FinalPoints(cards: crib).finalPoints(cut: cut, isCrib: true)
        }
        playerHand.removeAll()
        botHand.removeAll()
        discardPile.removeAll()
        playerStarts.toggle()
        discardRound = 0
        playerTurn = false
        pointCountingTime = nil
        dealCards()
    }
}
