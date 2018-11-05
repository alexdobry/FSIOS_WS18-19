//
//  Card.swift
//  MatchingCardGame
//
//  Created by Student on 16.10.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

enum Suit: String, CaseIterable {
    case spade = "♠️"
    case club = "♣️"
    case heart = "❤️"
    case diamond = "♦️"
}

enum Rank: String, CaseIterable {
    case two = "2", three = "3", four = "4", five = "5", six = "6", seven = "7", eight = "8", nine = "9", ten = "10"
    case J, Q, K, A
}

struct Card: CustomStringConvertible, Equatable {
    let suit: Suit
    let rank: Rank
    
    var description: String {
        return "\(suit.rawValue)\(rank.rawValue)"
    }
}

struct Deck: CustomStringConvertible {
    var cards = [Card]()
    
    init() {
        for suit in Suit.allCases {
            for rank in Rank.allCases {
                let card = Card(suit: suit, rank: rank)
                cards.append(card)
            }
        }
        
        cards.shuffle()
    }
    
    var description: String {
        return cards.description
    }
    
    mutating func drawRandomCard() -> Card? {
        if cards.isEmpty { return nil }
        return cards.removeFirst()
    }
}
