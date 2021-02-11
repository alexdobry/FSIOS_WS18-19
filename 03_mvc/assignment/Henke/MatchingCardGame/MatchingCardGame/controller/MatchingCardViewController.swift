//
//  MatchingCardViewController.swift
//  MatchingCardGame
//
//  Created by Student on 16.10.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit

class MatchingCardViewController: UIViewController {
    
    // View
    @IBOutlet var cardViews: [CardView]!
    @IBOutlet weak var scoreLabel: UILabel!
    
    // Model
    var game: MatchingCardGame!
    
    // Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardViews.forEach { cardView in
            cardView.delegate = self
        }
        
        initGame()
    }
    
    // Interaction
    
    @IBOutlet weak var playAgainButton: UIButton!
    
    @IBAction func playAgain(_ sender: Any) {

        cardViews.forEach { cardView in
            cardView.matched = false
            cardView.card = nil
        }
        
        initGame()
    }
    
    // Helper
    private func initGame() {
        scoreLabel.text = "Score: 0"
        game = MatchingCardGame(numberOfCards: cardViews.count)
        game.delegate = self
        playAgainButton.isHidden = true
    }
    
    func cardView(matching card: Card) -> CardView {
        return cardViews.first(where: { (cardView: CardView) -> Bool in
            return cardView.card == card
        })!
    }
}

extension MatchingCardViewController: CardViewDelegate {
    
    func cardView(_ cardView: CardView, tapped card: Card?) {
        let index = cardViews.firstIndex(of: cardView)!
        let result = game.flipCard(at: index)
        
        switch result {
        case .pending(let card):
            cardView.card = card
            
        case .noMatch(let pending, let card):
            cardView.card = card
            
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                cardView.card = nil
                
                let other = self.cardView(matching: pending)
                other.card = nil
            }
            
        case let .match(pending, card):
            cardView.card = card
            
            let other = self.cardView(matching: pending)
            other.matched = true
            cardView.matched = true
            
        case .alreadySelected: break
            //            sender.setTitle("NO", for: .normal)
            //
            //            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            //                sender.setTitle(card.description, for: .normal)
            //            }
        }
    }
}

extension MatchingCardViewController: MatchingCardGameDelegate {
    func cardsAreFlipped(_ result: FlippingCardResult) {
        print(result)
    }
    
  func matchingCardGamePairsToFind(to result: Bool) {
    playAgainButton.isHidden = false
    }
    
    func matchingCardGameScoreDidChange(to value: Int) {
        scoreLabel.text = "Score: \(value)"
    }
}
