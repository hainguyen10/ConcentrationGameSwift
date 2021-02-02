//
//  Concentration.swift
//  Concentration
//
//  Created by Son Nguyen  on 8/13/20.
//  Copyright © 2020 Hai Nguyen. All rights reserved.
//

import Foundation
struct Concentration {
    private (set) var cards = [Card]()
    private (set) var matches = 0
    private (set)  var score = 0
    private (set) var bonus = ""
    private var startTime: Date?
    private var elapsedTime: TimeInterval?
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            let faceUpCardIndices = cards.indices.filter {cards[$0].isFaceUp }
            return faceUpCardIndices.count == 1 ? faceUpCardIndices.first : nil
        }
    set {
        for index in cards.indices {
            cards[index].isFaceUp = (index == newValue)
        }
    }
}    
    mutating func chooseCard(at index: Int){
        assert (cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the cards")
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                stoppTime()
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    matches += 1
                    score += 2
                    if elapsedTime != nil {
                        if elapsedTime! < 0.75 {
                            bonus = "Time Bonus: +2"
                            score += 2
                        } else if elapsedTime! < 1.0 {
                            bonus = "Time Bonus: +1"
                            score += 1
                        }
                    }
                }else if cards[index].flipCount > 0 || cards[matchIndex].flipCount > 0 {
                    if elapsedTime != nil {
                        if elapsedTime! > 2.25{
                            bonus = "Time Deduction: -2"
                            score -= 2
                        }
                    }
                    score -= 1
                }
                cards[index].isFaceUp = true
                cards[index].flipCount += 1
                cards[matchIndex].flipCount += 1
            } else {
            indexOfOneAndOnlyFaceUpCard = index
        }
    }
    let numberOfFaceUpCards = cards.indices.filter { cards[$0].isFaceUp}.count
        if numberOfFaceUpCards == 1 {
            startTime = Date()
        } else {
            elapsedTime = nil
        }
    }
    private mutating func stoppTime() {
        if let start = startTime {
            elapsedTime = Date().timeIntervalSince(start)
        }
    }
    mutating func resetTimeBonus() {
        bonus = ""
    }
    mutating func resetCards() {
        cards.removeAll()
    }
    init(numberOfPairsOfCards: Int){
        assert(numberOfPairsOfCards > 0, "Concentration.init (\(numberOfPairsOfCards)): chosen index not in the cards")
        
        var preShuffledCards = [Card]()
        for _ in 0...numberOfPairsOfCards {
            let card = Card()
            preShuffledCards += [card, card]
        }
        for _ in preShuffledCards {
            let randomIndex = preShuffledCards.count.arc4random
            let randomCard = preShuffledCards.remove(at: randomIndex)
            cards.append(randomCard)
        }
    }
}
extension Double {
    func rounded(by decimalPlaces: Int) -> Double {
        let divisor = pow(10.0, Double(decimalPlaces))
        return (self * divisor).rounded() / divisor
    }
}
