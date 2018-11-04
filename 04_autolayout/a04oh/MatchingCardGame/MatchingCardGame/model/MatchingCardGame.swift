//
//  MatchingCardGame.swift
//  MatchingCardGame
//
//  Created by Student on 19.10.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

enum FlippingCardResult {
    case pending(Card)
    case match(Card, Card)
    case noMatch(Card, Card)
    case alreadySelected(Card)
}

protocol MatchingCardGameDelegate {
    func matchingCardGameScoreDidChange(to score: Int)
    func matchingCardGameDidEnd(with cards: [Card])
}

final class MatchingCardGame {
    private(set) var cards: [Card] = []
    private var pendingCard: Card?
    
    private var matched: [Card]
    
    private var pendingCards: [Card] {
        return cards.filter { card in
            !matched.contains(card)
        }
    }
    
    private var isMatchingPossible: Bool {
        let p = pendingCards
        
        let ranks = Dictionary(grouping: p, by: { $0.rank }).contains(where: { $0.value.count >= 2 })
        let suits = Dictionary(grouping: p, by: { $0.suit }).contains(where: { $0.value.count >= 2 })
        
        return ranks || suits
    }
    
    private var globalScore: Int = 0 {
        didSet {
            delegate?.matchingCardGameScoreDidChange(to: globalScore)
        }
    }
    
    var delegate: MatchingCardGameDelegate?

    init(numberOfCards: Int) {
        self.matched = []
        
        var deck = Deck()
        
        guard deck.cards.count >= numberOfCards else {
            fatalError("not enough cards in deck")
        }
        
        for _ in (0..<numberOfCards) {
            if let card = deck.drawRandomCard() {
                cards.append(card)
            }
        }
    }
    
    func flipCard(at index: Int) -> FlippingCardResult {
        let card = cards[index]
        let result: FlippingCardResult
        
        guard card != pendingCard else {
            result = .alreadySelected(card)
            return result
        }
        
        if let pending = pendingCard {
            pendingCard = nil
            
            if pendingCard(pending, isMatchingWith: card) {
                matched.append(contentsOf: [pending, card])
                result = .match(pending, card)
            } else {
                result = .noMatch(pending, card)
            }
        } else {
            pendingCard = card
            result = .pending(card)
        }
        
        if !isMatchingPossible {
            delegate?.matchingCardGameDidEnd(with: pendingCards)
        }
        
        return result
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
