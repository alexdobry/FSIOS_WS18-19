//
//  CardView.swift
//  MatchingCardGame
//
//  Created by Alex Dobrynin on 23.10.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit

protocol CardViewDelegate {
    func cardView(_ cardView: CardView, tapped card: Card?)
}

@IBDesignable
class CardView: CustomView {

    @IBOutlet weak var ImageView: UIImageView!
    
    var delegate: CardViewDelegate?
    
    var card: Card? {
        didSet {
            if let card = card {
                ImageView.image = image(for: card)
            } else {
                ImageView.image = #imageLiteral(resourceName: "card_back")
            }
        }
    }
    
    @IBInspectable
    var matched: Bool = false {
        didSet {
            isUserInteractionEnabled = !matched
            alpha = matched ? 0.5 : 1.0
        }
    }
    
    func image(for card: Card) -> UIImage? {
        let rank: String
        
        switch card.rank {
        case .J:
            rank = "jack"
        case .Q:
            rank = "queen"
        case .K:
            rank = "king"
        case .A:
            rank = "ace"
        case _:
            rank = card.rank.rawValue
        }
        
        let suit: String
        
        switch card.suit {
        case .club:
            suit = "clubs"
        case .diamond:
            suit = "diamonds"
        case .heart:
            suit = "hearts"
        case .spade:
            suit = "spades"
        }
        
        return UIImage(named: "\(rank)_of_\(suit)")
    }
    
    @IBAction func cardTapped(_ sender: Any) {
        delegate?.cardView(self, tapped: card)
    }
}
