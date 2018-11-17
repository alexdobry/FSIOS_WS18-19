//
//  CardView.swift
//  MatchingCardGame
//
//  Created by Student on 19.10.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit

protocol CardViewDelegate {
    func cardView(_ cardView: CardView, flippedWith card: Card?)
}

@IBDesignable
class CardView: CustomView {
    
    @IBOutlet weak var cardImageView: UIImageView!
    
    var delegate: CardViewDelegate?
    
    var card: Card? = nil {
        didSet {
            UIView.transition(
                with: self,
                duration: 0.3,
                options: card != nil ? .transitionFlipFromLeft : .transitionFlipFromRight,
                animations: {
                    if let card = self.card {
                        self.cardImageView.image = self.image(for: card)
                    } else {
                        self.cardImageView.image = #imageLiteral(resourceName: "card_back")
                    }
                },
                completion: nil
            )

        }
    }
    
    @IBInspectable
    var matched: Bool = false {
        didSet {
            let duration = 1.0
            
            UIView.animate(
                withDuration: duration / 2,
                delay: 0.0,
                usingSpringWithDamping: 0.5,
                initialSpringVelocity: 0.5,
                options: [],
                animations: {
                    self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                },
                completion: { _ in
                    UIView.animate(
                        withDuration: duration / 2,
                        animations: {
                            self.transform = CGAffineTransform.identity
                            self.alpha = self.matched ? 0.5 : 1.0
                        }
                    )
                }
            )
            
            self.isUserInteractionEnabled = !self.matched
        }
    }
    // Already Selected on View
    @IBInspectable
    var alreadySelected: Bool = false {
        didSet {
            let duration = 0.4
            
            UIView.animate(
                withDuration: duration / 2,
                delay: 0.0,
                options: [],
                animations: {
                    self.transform = CGAffineTransform(translationX: 2.0, y: 0)
            },
                completion: { _ in
                    UIView.animate(
                        withDuration: duration / 2,
                        animations: {
                            UIView.animate(
                                withDuration: duration / 2,
                                delay: 0.0,
                                options: [],
                                animations: {
                                    self.transform = CGAffineTransform(translationX: -2.0, y: 0)
                            },
                                completion: { _ in
                                    UIView.animate(
                                        withDuration: duration / 2,
                                        animations: {
                                            self.transform = CGAffineTransform.identity
                                    }
                                    )
                            }
                            )
                    }
                    )
            }
            )
        }
    }
    
    private func image(for card: Card) -> UIImage? {
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
    
    @IBAction func cardViewTapped(_ sender: UITapGestureRecognizer) {
        delegate?.cardView(self, flippedWith: card)
    }
}
