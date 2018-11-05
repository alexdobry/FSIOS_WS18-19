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
//    func pending(index: Int, card: Card)
//    func match(index: Int, first: Card, second: Card)
//    func noMatch(index: Int, first: Card, second: Card)
    func match(_ index: Int, _ pending: Card, _ card: Card)
    func noMatch(_ index: Int, _ pending: Card, _ card: Card)
    func pending(_ index: Int, _ card: Card)
    func alreadySelected(index: Int, card: Card)
    func matchingCardGameOver()
}

final class MatchingCardGame {
    private var cards: [Card] = []
    
    private var pendingCard: Card?
    
    private var globalScore: Int {
        didSet {
            delegate?.matchingCardGameScoreDidChange(to: globalScore)
        }
    }
    
    var delegate: MatchingCardGameDelegate?
    
    init(numberOfCards: Int) {
        globalScore = 0
        
        var deck = Deck()
        
        for _ in (0..<numberOfCards) { // matching cardButtons with gameCards (1 to 1)
            if let card = deck.drawRandomCard() {
                cards.append(card)
            }
        }
    }
    
    private var isMatchingPossible: Bool {
        let cardsLeft = cards.filter({$0.matched==false})
        let ranks = Dictionary(grouping: cardsLeft, by: { $0.rank }).contains(where: { $0.value.count >= 2 })
        let suits = Dictionary(grouping: cardsLeft, by: { $0.suit }).contains(where: { $0.value.count >= 2 })
        return ranks || suits
    }
    
    func flipCard(at index: Int){
        let card = cards[index]
        
        if pendingCard != card {
            if let pending = pendingCard {
                pendingCard = nil
                
                if pendingCard(pending, isMatchingWith: card) {
                    let pendingIndex = cards.firstIndex(of: pending)!
                    cards[pendingIndex].matched = true
                    cards[index].matched = true
                    delegate?.match(index , pending, card)
                } else {
                    delegate?.noMatch(index, pending, card)
                }
                
            } else {
                pendingCard = card
                delegate?.pending(index, card)
            }
        } else {
            delegate?.alreadySelected(index: index, card: card)
        }
        
        if !isMatchingPossible {
            delegate?.matchingCardGameOver()
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
}
