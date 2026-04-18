//
//  PointSummary.swift
//  Cribbage
//
//  Created by Ajay Yamamoto on 2026-04-12.
//

import SwiftUI

struct PointOverlay: View {
    let title: String
    let cards: [Card]
    let cut: Card
    let isCrib: Bool
    let onNext: () -> Void
    
    var body: some View {
        ZStack {
            Text(title)
                .font(Font.largeTitle.bold())
                .position(x: 500, y: 45)
            HStack {
                ForEach(cards, id: \.self) { card in
                    cardNotButton(height: 200, card: card)
                }
                .position(x: 97, y: 180)
            }
            VStack(alignment: .leading) {
                Spacer()
                Text("Points from pairs: \(FinalPoints(cards: cards).checkPairs())")
                    .font(Font.title.bold())
                Spacer()
                Text("Points from runs: \(FinalPoints(cards: cards).checkRuns())")
                    .font(Font.title.bold())
                Spacer()
                Text("Points from fifteens: \(FinalPoints(cards: cards).checkFifteens())")
                    .font(Font.title.bold())
                Spacer()
                Text("Point from miscellaneous: \(FinalPoints(cards: cards).checkFlush(isCrib: isCrib) + FinalPoints(cards: cards).checkNob(cut: cut))")
                    .font(Font.title.bold())
                Spacer()
            }
            .position(x: 180, y: 350)
            .frame(height: 400)
            
            VStack {
                Text("TOTAL")
                    .bold()
                Text("\(FinalPoints(cards: cards).finalPoints(cut: cut, isCrib: isCrib))")
                    .font(.system(size: 100))
            }
            .position(x: 700, y: 500)
            
            Button("Next") {
                onNext()
            }
            .buttonStyle(.glass)
            .position(x: 500, y: 650)
        }
        .frame(width: 1000, height: 700)
        .background(Color.green.opacity(0.7))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
}
