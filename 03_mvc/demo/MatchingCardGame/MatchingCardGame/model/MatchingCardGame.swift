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
}

enum FlippingCardResult {
    case pending(Card)
    case match(first: Card, second: Card)
    case noMatch(first: Card, second: Card)
    case alreadySelected(Card)
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
    
    func flipCard(at index: Int) -> FlippingCardResult {
        let card = cards[index]
        
        if pendingCard == card {
            return .alreadySelected(card)
        }
        
        if let pending = pendingCard {
            pendingCard = nil

            if pendingCard(pending, isMatchingWith: card) {
                return .match(first: pending, second: card)
            } else {
                return .noMatch(first: pending, second: card)
            }
            
        } else {
            pendingCard = card
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
}
