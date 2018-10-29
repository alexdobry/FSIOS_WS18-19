//
//  MatchingCardViewController.swift
//  MatchingCardGame
//
//  Created by Student on 16.10.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit

class MatchingCardViewController: UIViewController {

    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var scoreLabel: UILabel!
    
    
    
    @IBOutlet weak var ButtonReset: UIButton!
    
    var gameCards = [Card]()
    
    var pendingCard: Card?
    
    var userFlippedCard: Bool = false
    
    var globalScore = 0 {
        didSet {
            scoreLabel.text = "Score: \(globalScore)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startCardGame()
    }

    // first turn: pending
    // if pending: match or no match
    // repeat
    
    @IBAction func flipCard(_ sender: UIButton) {
        let index = cardButtons.firstIndex(of: sender)!
        let card = gameCards[index]
        userFlippedCard = true
        
        if let pending = pendingCard {
            if card.description != pendingCard?.description {
                if pendingCard(pending, isMatchingWith: card) {
                    sender.isUserInteractionEnabled = false
                    
                    let pendingButton = cardToButton(matching: pending)

                    pendingButton.isUserInteractionEnabled = false
                    flip(sender, to: card)
                    
                } else {
                    flip(sender, to: card)
                    
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                        self.flip(sender, to: card)
                        
                        let other = self.cardToButton(matching: pending)
                        self.flip(other, to: pending)
                    }
                }
                pendingCard = nil
            }
        } else {
            flip(sender, to: card)
            pendingCard = card
        }
    }
    
    func pendingCard(_ pendingCard: Card, isMatchingWith card: Card) -> Bool {
        var localScore = 0
        
        if pendingCard.suit == card.suit {
            localScore += 5
        }
        
        if pendingCard.rank == card.rank {
            localScore += 5 * 2
        }
        
        
        if localScore == 0 || localScore >= 15{
            globalScore -= 3
        } else {
            globalScore += localScore
        }
        
        return localScore > 0
    }
    
    func cardToButton(matching card: Card) -> UIButton {
        return cardButtons.first(where: { (button: UIButton) -> Bool in
            return button.currentTitle == card.description
        })!
    }
    
    func buttonToCard(matching button: UIButton) -> Card {
        return gameCards.first(where: { (card: Card) -> Bool in
            return card.description == button.currentTitle
        })!
    }
    
    func resetCardButtons(){
        for cardButton in cardButtons{
            if !cardButton.isUserInteractionEnabled {
                cardButton.isUserInteractionEnabled = true
                let matching: Card = buttonToCard(matching: cardButton)
                flip(cardButton, to: matching)
            }
        }
        if pendingCard != nil {
            let button = cardToButton(matching: pendingCard!)
            flip(button, to: pendingCard!)
            pendingCard = nil
        }
        userFlippedCard = false
    }
    
    @IBAction func startCardGame() {
        globalScore = 0
        
        var deck = Deck()
        let numberOfCards = cardButtons.indices
        
        if userFlippedCard == true {
            resetCardButtons()
        }
        
        gameCards = [Card]()
        
        for _ in numberOfCards { // matching cardButtons with gameCards (1 to 1)
            if let card = deck.drawRandomCard() {
                gameCards.append(card)
            }
        }
        
        assert(gameCards.count == cardButtons.count)
    }
    
    
    
    func flip(_ button: UIButton, to card: Card) {
        if button.currentTitle == nil {
            // back
            button.setBackgroundImage(#imageLiteral(resourceName: "card_front"), for: .normal)
            button.setTitle(card.description, for: .normal)
        } else {
            // front
            button.setBackgroundImage(#imageLiteral(resourceName: "card_back"), for: .normal)
            button.setTitle(nil, for: .normal)
        }
    }
}
