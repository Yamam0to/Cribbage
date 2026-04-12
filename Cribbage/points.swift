//
//  points.swift
//  Cribbage
//
//  Created by Ajay Yamamoto on 2026-04-06.
//

import SwiftUI

struct FinalPoints {
    let cards: [Card]
    var points = 0
    
    func checkFlush(isCrib: Bool) -> Int {
        var mini = true
        var big = true
        for i in 1...3 {
            if cards[0].suit != cards[i].suit {
                mini = false
                big = false
            }
        }
        
        for i in 1...4 {
            if cards[0].suit != cards[i].suit {
                big = false
            }
        }
        if big == true {
            return 5
        } else if mini == true {
            if isCrib {
                return 0
            } else {
                return 4
            }
        } else {
            return 0
        }
    }
    
    func checkNob(cut: Card) -> Int {
        if cards.contains(where: { $0.rank == .jack && $0.suit == cut.suit }) {
            return 1
        } else {
            return 0
        }
    }
    
    func checkPairs() -> Int {
        var total = 0
        for num in 1...4 {
            if self.cards[0].rank == self.cards[num].rank {
                total += 2
            }
        }
        for num in 2...4 {
            if self.cards[1].rank == self.cards[num].rank {
                total += 2
            }
        }
        for num in 3...4 {
            if self.cards[2].rank == self.cards[num].rank {
                total += 2
            }
        }
        if self.cards[3].rank == self.cards[4].rank {
            total += 2
        }
        return total
    }
    
    func checkRuns() -> Int {
        var total = 0
        var rankArray: [Int] = []
        
        for card in self.cards {
            rankArray.append(card.rank.rawValue)
        }
        rankArray.sort()
        
        var individual: [Int] = []
        var currentIndividual = 0
        
        for num in 0..<rankArray.count {
            if currentIndividual != rankArray[num] {
                individual.append(rankArray[num])
                currentIndividual = rankArray[num]
            }
        }
        //checking if it is a run (individual)
        var run: [Int] = []
        if individual.count == 3 {
            if individual[0] + 2 == individual[2] {
                run = individual
            }
        }
        if individual.count == 4 {
            if individual[0] + 2 == individual[2] {
                if individual[0] + 3 == individual[3] {
                    run = individual
                } else {
                    run.append(individual[0])
                    run.append(individual[1])
                    run.append(individual[2])
                }
            } else if individual[1] + 2 == individual[3] {
                run.append(individual[1])
                run.append(individual[2])
                run.append(individual[3])
            }
        }
        if individual.count == 5 {
            if individual[0] + 2 == individual[2] {
                if individual[0] + 3 == individual[3] {
                    if individual[0] + 4 == individual[4] {
                        run = individual
                    } else {
                        run.append(individual[0])
                        run.append(individual[1])
                        run.append(individual[2])
                        run.append(individual[3])
                    }
                } else {
                    run.append(individual[0])
                    run.append(individual[1])
                    run.append(individual[2])
                }
            }
            if individual[1] + 2 == individual[3] {
                if individual[1] + 3 == individual[4] {
                    run.append(individual[1])
                    run.append(individual[2])
                    run.append(individual[3])
                    run.append(individual[4])
                } else {
                    run.append(individual[1])
                    run.append(individual[2])
                    run.append(individual[3])
                }
            }
            if individual[2] + 2 == individual[4] {
                run.append(individual[2])
                run.append(individual[3])
                run.append(individual[4])
            }
        }
        
        //scoring the run
        var currentAdd = 0
        var multiplier = 1
        for thing in run {
            for num in 0...4 {
                if thing == rankArray[num] {
                    currentAdd += 1
                }
            }
            multiplier *= currentAdd
            currentAdd = 0
        }
        
        total = run.count * multiplier
        return total
    }
    
    func checkFifteens() -> Int {
        var total = 0
        let numArray = self.cards.map {$0.rank.value}
        
        // for 2
        for a in 0...3 {
            for b in a + 1...4 {
                if numArray[a] + numArray[b] == 15 {
                    total += 2
                }
            }
        }
        // for 3
        for a in 0...2 {
            for b in a + 1...3 {
                for c in b + 1...4 {
                    if numArray[a] + numArray[b] + numArray[c] == 15 {
                        total += 2
                    }
                }
            }
        }
        
        // for 4
        for a in 0...1 {
            for b in a + 1...2 {
                for c in b + 1...3 {
                    for d in c + 1...4 {
                        if numArray[a] + numArray[b] + numArray[c] + numArray[d] == 15 {
                            total += 2
                        }
                    }
                }
            }
        }
        
        // for 5
        if numArray[0] + numArray[1] + numArray[2] + numArray[3] + numArray[4] == 15 {
            total += 2
        }
        return total
    }
    
    func finalPoints(cut: Card, isCrib: Bool) -> Int {
        return checkFifteens() + checkRuns() + checkPairs() + checkNob(cut: cut) + checkFlush(isCrib: isCrib)
    }
}

struct PeggingPoints {
    func peggingPoints(cards: [Card], count: Int) -> Int {
        var points = 0
        //fifteens
        if count == 15 {
            points += 2
        }
        //pairs
        var pairCount = 0
        let lastRank = cards.last?.rank
        for i in (0..<cards.count - 1).reversed() {
            if cards[i].rank == lastRank {
                    pairCount += 1
                } else {
                    break
                }
            }
        if pairCount == 1 {
            points += 2
        } else if pairCount == 2 {
            points += 6
        } else if pairCount == 3 {
            points += 12
        }
        //runs
        if cards.count >= 3 {
            for i in 3...cards.count {
                let lastI = cards.suffix(i)
                let values = lastI.map { $0.rank.rawValue }
                
                if Set(values).count != values.count {
                    continue
                }
                
                let sortedValues = values.sorted()
                if sortedValues.last! - sortedValues.first! == i - 1 {
                    points += i
                }
            }
        }
        
        //31
        if count == 31 {
            points += 2
        }
        return points
    }
}

struct PointOverlay: View {
    @ObservedObject var game: GameState
    @State private var screen = 1
    var body: some View {
        if screen == 1 {
            ZStack {
                Text("Your Hand (with cut)")
                    .font(Font.largeTitle.bold())
                    .position(x: 500, y: 45)
                HStack {
                    ForEach(game.afterPlayerHand, id: \.self) { card in
                        CardButton(card: card, game: game)
                    }
                    .position(x: 97, y: 180)
                }
                VStack(alignment: .leading) {
                    Spacer()
                    Text("Points from pairs: \(FinalPoints(cards: game.afterPlayerHand).checkPairs())")
                        .font(Font.title.bold())
                    Spacer()
                    Text("Points from runs: \(FinalPoints(cards: game.afterPlayerHand).checkRuns())")
                        .font(Font.title.bold())
                    Spacer()
                    Text("Points from fifteens: \(FinalPoints(cards: game.afterPlayerHand).checkFifteens())")
                        .font(Font.title.bold())
                    Spacer()
                    Text("Point from miscellaneous: \(FinalPoints(cards: game.afterPlayerHand).checkFlush(isCrib: false) + FinalPoints(cards: game.afterPlayerHand).checkNob(cut: game.cut))")
                        .font(Font.title.bold())
                    Spacer()
                }
                .position(x: 180, y: 350)
                .frame(height: 400)
                
                VStack {
                    Text("TOTAL")
                        .bold()
                    Text("\(FinalPoints(cards: game.afterPlayerHand).finalPoints(cut: game.cut, isCrib: false))")
                        .font(.system(size: 100))
                }
                .position(x: 700, y: 500)
                
                Button("Next") {
                    screen += 1
                }
                .buttonStyle(.glass)
                .position(x: 500, y: 650)
            }
            .frame(width: 1000, height: 700)
            .background(Color.green.opacity(0.7))
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        if screen == 2 {
            ZStack {
                Text("Bot's hand (with cut)")
                    .font(Font.largeTitle.bold())
                    .position(x: 500, y: 45)
                HStack {
                    ForEach(game.afterBotHand, id: \.self) { card in
                        CardButton(card: card, game: game)
                    }
                    .position(x: 97, y: 180)
                }
                VStack(alignment: .leading) {
                    Spacer()
                    Text("Points from pairs: \(FinalPoints(cards: game.afterBotHand).checkPairs())")
                        .font(Font.title.bold())
                    Spacer()
                    Text("Points from runs: \(FinalPoints(cards: game.afterBotHand).checkRuns())")
                        .font(Font.title.bold())
                    Spacer()
                    Text("Points from fifteens: \(FinalPoints(cards: game.afterBotHand).checkFifteens())")
                        .font(Font.title.bold())
                    Spacer()
                    Text("Point from miscellaneous: \(FinalPoints(cards: game.afterBotHand).checkFlush(isCrib: false) + FinalPoints(cards: game.afterBotHand).checkNob(cut: game.cut))")
                        .font(Font.title.bold())
                    Spacer()
                }
                .position(x: 180, y: 350)
                .frame(height: 400)
                
                VStack {
                    Text("TOTAL")
                        .bold()
                    Text("\(FinalPoints(cards: game.afterBotHand).finalPoints(cut: game.cut, isCrib: false))")
                        .font(.system(size: 100))
                }
                .position(x: 700, y: 500)
                
                Button("Next") {
                    screen += 1
                }
                .buttonStyle(.glass)
                .position(x: 500, y: 650)
            }
            .frame(width: 1000, height: 700)
            .background(Color.green.opacity(0.7))
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        if screen == 3 {
            ZStack {
                Text(game.playerStarts ? "Your Crib" : "Bot's Crib")
                    .font(Font.largeTitle.bold())
                    .position(x: 500, y: 45)
                HStack {
                    ForEach(game.crib, id: \.self) { card in
                        CardButton(card: card, game: game)
                    }
                    .position(x: 97, y: 180)
                }
                VStack(alignment: .leading) {
                    Spacer()
                    Text("Points from pairs: \(FinalPoints(cards: game.crib).checkPairs())")
                        .font(Font.title.bold())
                    Spacer()
                    Text("Points from runs: \(FinalPoints(cards: game.crib).checkRuns())")
                        .font(Font.title.bold())
                    Spacer()
                    Text("Points from fifteens: \(FinalPoints(cards: game.crib).checkFifteens())")
                        .font(Font.title.bold())
                    Spacer()
                    Text("Point from miscellaneous: \(FinalPoints(cards: game.crib).checkFlush(isCrib: true) + FinalPoints(cards: game.crib).checkNob(cut: game.cut))")
                        .font(Font.title.bold())
                    Spacer()
                }
                .position(x: 180, y: 350)
                .frame(height: 400)
                
                VStack {
                    Text("TOTAL")
                        .bold()
                    Text("\(FinalPoints(cards: game.crib).finalPoints(cut: game.cut, isCrib: true))")
                        .font(.system(size: 100))
                }
                .position(x: 700, y: 500)
                
                Button("Next") {
                    screen = 0
                    game.reset()
                }
                .buttonStyle(.glass)
                .position(x: 500, y: 650)
            }
            .frame(width: 1000, height: 700)
            .background(Color.green.opacity(0.7))
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
}
