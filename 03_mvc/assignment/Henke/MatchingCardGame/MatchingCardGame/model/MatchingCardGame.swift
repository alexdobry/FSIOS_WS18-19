//
//  MatchingCardGame.swift
//  MatchingCardGame
//
//  Created by Alex Dobrynin on 23.10.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

protocol MatchingCardGameDelegate {
    func matchingCardGameScoreDidChange(to value: Int)
    func matchingCardGamePairsToFind(to result: Bool)
    func cardsAreFlipped(_ result: FlippingCardResult)
}


enum FlippingCardResult {
    case pending(Card)
    case match(first: Card, second: Card)
    case noMatch(first: Card, second: Card)
    case alreadySelected(Card)
}

final class MatchingCardGame {
    private var cards: [Card] = []
    //erzeuge Copy
    private var cardsTemp: [Card] = []
    
    private var pendingCard: Card?
    
    private var globalMatchedCards = 0
    
    private var globalScore: Int {
        didSet {
            delegate?.matchingCardGameScoreDidChange(to: globalScore)
        }
    }
    
    
    private var PairsFound: Bool {
        didSet {
            delegate?.matchingCardGamePairsToFind(to: PairsFound)
        }
    }
    
    var delegate: MatchingCardGameDelegate?
    
  
    init(numberOfCards: Int) {
        globalScore = 0
        PairsFound = true
        
        var deck = Deck()
        
        for _ in (0..<numberOfCards) { // matching cardButtons with gameCards (1 to 1)
            if let card = deck.drawRandomCard() {
                cards.append(card)
                //für Copy
                cardsTemp.append(card)
            }
        }
    }
    
    func flipCard(at index: Int) -> FlippingCardResult {
        let card = cards[index]
        var matchedCardsLocal = 0
   
        
        if pendingCard == card {
            delegate?.cardsAreFlipped(.alreadySelected(card))
            return .alreadySelected(card)
        }
        
        if let pending = pendingCard {
            pendingCard = nil

            if pendingCard(pending, isMatchingWith: card) {
                matchedCardsLocal += 1
                globalMatchedCards += matchedCardsLocal
        
                cardsTemp.index(of: card).map{ cardsTemp.remove(at: $0) }
                cardsTemp.index(of: pending).map{ cardsTemp.remove(at: $0) }
       
                let cardIndex: Int = cards.firstIndex(of: cards[index])!
             
                potentialMatches()

                delegate?.cardsAreFlipped(.match(first: pending, second: card))
                
                return .match(first: pending, second: card)
            } else {
                delegate?.cardsAreFlipped(.noMatch(first: pending, second: card))
                return .noMatch(first: pending, second: card)
            }
            
        } else {
            pendingCard = card
            delegate?.cardsAreFlipped(.pending(card))
            return .pending(card)
        }
    }
    
    private func pendingCard(_ pendingCard: Card, isMatchingWith card: Card) -> Bool {
        var localScore = 0
        
        if pendingCard.suit == card.suit {
            localScore += 5
        }
        
        if pendingCard.rank == card.rank {
            localScore += 5 * 2
        }
        
        globalScore += localScore
        
        
        
        return localScore > 0
    }
    
    func potentialMatches() -> Bool {
        var paareCounter = 0

        for i in 0..<cardsTemp.count-1 {
            for j in 0..<cardsTemp.count-1 {

                if cardsTemp[i] != cardsTemp[j] {
                    if cardsTemp[i].suit == cardsTemp[j].suit || cardsTemp[i].rank == cardsTemp[j].rank {
                        paareCounter += 1
                    }
                }
            }
        }
        print("Es gibt noch Paare, die nicht aufgedeckt wurden")
        
        if paareCounter == 0 {
            PairsFound = false
            print("Game Over")
        }
        return paareCounter == 0
    }
}
