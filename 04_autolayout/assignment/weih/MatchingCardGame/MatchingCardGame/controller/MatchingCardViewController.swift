//
//  MatchingCardViewController.swift
//  MatchingCardGame
//
//  Created by Student on 16.10.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit

class MatchingCardViewController: UIViewController {
    
    @IBOutlet var cardViews: [CardView]!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var restartButton: UIButton!
    
    var game: MatchingCardGame!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restartGame()
        dealCards()
    }
    
    private func restartGame() {
        scoreLabel.text = "Score: 0"
        
        // Restart Button Reseting alpha on Controller
        restartButton.alpha = 0
        
        game = MatchingCardGame(numberOfCards: cardViews.count)
        game.delegate = self
        
        cardViews.forEach { cardView in
            cardView.delegate = self
            cardView.matched = false
            cardView.card = nil
        }
    }
    
    @IBAction func restartGame(_ sender: Any) {
        restartGame()
        dealCards()
    }
    
    func dealCards() {
        let bottomEdge = CGPoint(x: view.frame.width / 2, y: view.frame.height)
        
        cardViews.forEach { cardView in
            let distanceX = bottomEdge.x - cardView.center.x
            let distanceY = bottomEdge.y - cardView.center.y
            
            cardView.transform = CGAffineTransform(translationX: distanceX, y: distanceY - cardView.bounds.height / 2)
        }
        
        let totalDuration = Double(cardViews.count) / 12 // 6
        let singleDuration = totalDuration / Double(cardViews.count) // 0.5
        
        cardViews.shuffled().enumerated().forEach { arg in
            let (i, cardView) = arg
            let delay = singleDuration * Double(i)
            
            UIView.animate(
                withDuration: totalDuration,
                delay: delay,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0.2,
                options: [],
                animations: { cardView.transform = .identity },
                completion: nil
            )
        }
    }
}

extension MatchingCardViewController: MatchingCardGameDelegate {

    func matchingCardGameScoreDidChange(to score: Int) {
        scoreLabel.text = "Score: \(score)"
    }
    
    func matchingCardGameDidEnd(with cards: [Card]) {
        print("game over with cards: ", cards)
        
        self.cardViews.forEach {
            $0.matched = true
        }
        
        // Restart Button Animation on Controller
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       options: [],
                       animations: {
                            self.restartButton.alpha = 1.0
                            self.restartButton.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
                        },
                       completion: { _ in
                        UIView.animate(
                            withDuration: 0.5,
                            delay: 0.0,
                            options: [],
                            animations: {
                                self.restartButton.transform = CGAffineTransform.identity
                        }
                        )
                    }
                    )
        }
    }

extension MatchingCardViewController: CardViewDelegate {
    
    private func cardButton(matching card: Card) -> CardView {
        return cardViews.first(where: { (cardView: CardView) -> Bool in
            cardView.card == card
        })!
    }
    
    func cardView(_ cardView: CardView, flippedWith card: Card?) {
        let index = cardViews.firstIndex(of: cardView)!
        
        let result = game.flipCard(at: index)
        print(result)
        
        switch result {
        case .pending(let card):
            cardView.card = card
        case .match(let first, let second):
            cardView.card = second

            let other = self.cardButton(matching: first)
            cardView.matched = true
            other.matched = true
        case let .noMatch(first, second):
            cardView.card = second

            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                cardView.card = nil
                self.cardButton(matching: first).card = nil
            }
            // Already Selected on Controller
        case .alreadySelected(let card):            
            let selectedCard = self.cardButton(matching: card)
            selectedCard.alreadySelected = true
        }
    }
}
