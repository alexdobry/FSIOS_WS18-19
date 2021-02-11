import UIKit

struct Card: CustomStringConvertible {
    let suit: String
    let rank: String
    
    var description: String {
        return "\(suit)\(rank)"
    }
}

let spade = "♠️"
let club = "♣️"
let heart = "❤️"
let diamond = "♦️"

let suits = [spade, club, heart, diamond]
let ranks = (2...10).map { "\($0)" } + ["J", "Q", "K", "A"]

struct Deck: CustomStringConvertible {
    var cards = [Card]()
    
    init() {
        for suit in suits {
            for rank in ranks {
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

var deck = Deck()

for _ in (0..<52) {
    deck.drawRandomCard()?.description
    deck.cards.count
}
