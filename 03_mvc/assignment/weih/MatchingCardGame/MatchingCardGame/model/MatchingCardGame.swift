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
    func match(_ index: Int, _ pending: Card, _ card: Card)
    func noMatch(_ index: Int, _ pending: Card, _ card: Card)
    func pending(_ index: Int, _ card: Card)
    func restart()
}

final class MatchingCardGame {
    private var cards: [Card] = []
    private var cardsTmp: [Card] = []
    
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
        cardsTmp = cards
    }
    
    func flipCard(at index: Int) {
        let card = cards[index]
        
        if pendingCard != card {
            if let pending = pendingCard {
                pendingCard = nil

                if pendingCard(pending, isMatchingWith: card) {
                    delegate?.match(index , pending, card)
                    cardsTmp = cardsTmp.filter { $0.description != pending.description && $0.description != card.description}
                    if !findMatches() {
                        delegate?.restart()
                    }
                } else {
                    delegate?.noMatch(index, pending, card)
                }
                
            } else {
                pendingCard = card
                delegate?.pending(index, card)
            }
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
    
    private func findMatches() -> Bool {
        for index1 in (0..<cardsTmp.count){
            for index2 in (0..<cardsTmp.count){
                if index1 != index2 {
                    if cardsTmp[index1].rank == cardsTmp[index2].rank {
                        return true
                    } else if cardsTmp[index1].suit == cardsTmp[index2].suit {
                        return true
                    }
                }
            }
        }
        return false
    }
}
