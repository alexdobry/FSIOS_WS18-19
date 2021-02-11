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
    @IBOutlet weak var resetButton: UIButton!
    
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
        resetButton.isEnabled = false
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
        game.flipCard(at: index)
    }
}

extension MatchingCardViewController: MatchingCardGameDelegate {
    func matchingCardGameOver() {
        resetButton.isEnabled = true
    }
    
    func match(_ index: Int, _ pending: Card, _ card: Card){
        cardViews?[index].card = card
        let other = self.cardView(matching: pending)
        other.matched = true
        cardViews?[index].matched = true
    }
    
    func noMatch(_ index: Int, _ pending: Card, _ card: Card){
        cardViews?[index].card = card
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            self.cardViews?[index].card = nil
            
            let other = self.cardView(matching: pending)
            other.card = nil
        }
    }
    
    func pending(_ index: Int, _ card: Card){
        cardViews?[index].card = card
    }
    
    func alreadySelected(index: Int, card: Card) {
        print("You are dumb!")
    }
    
    func matchingCardGameScoreDidChange(to value: Int) {
        scoreLabel.text = "Score: \(value)"
    }
}
