//
//  MatchingCardViewController.swift
//  MatchingCardGame
//
//  Created by Student on 16.10.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit

class MatchingCardViewController: UIViewController {
    
    @IBOutlet var cardViews: [DrawingCardView]!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var restartButton: UIButton!
    
    private var scoreArray:[Int] = [0]
    
    
    var game: MatchingCardGame!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restartGame()
        dealCards()
    }
    
    @IBAction func restartGame(_ sender: Any) {
        restartGame()
        dealCards()
    }
    
    private func restartGame() {
        scoreLabel?.text = "Score: 0"
        restartButton?.isHidden = true
        
        game = MatchingCardGame(numberOfCards: cardViews.count)
        game.delegate = self
        
        cardViews.forEach { cardView in
            cardView.delegate = self
            cardView.matched = false
            cardView.card = nil
        }
    }
    
    private func dealCards() {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifer = segue.identifier else { return }
        
        switch identifer {
        case "SettingsSegue":
            let nav = segue.destination as! UINavigationController
            let settingsVC = nav.topViewController as! SettingsViewController
            settingsVC.increase = game.scoreIncrease
            settingsVC.decrease = game.scoreDecrease
            settingsVC.fieldBackground = view.backgroundColor
            settingsVC.lineWidth = cardViews.first?.lineWidth
            settingsVC.lines = cardViews.first?.lines
        case "HighscoreSegue":
            let highscoreVC = segue.destination as! HighscoreViewController
            highscoreVC.highscoreArray = scoreArray
            
        case _: break
        }
    }
    

    @IBAction func unwindFromSettingsVC(segue: UIStoryboardSegue) {
        guard let settingsVC = segue.source as? SettingsViewController else { return }
        
        game.scoreIncrease = settingsVC.increase
        game.scoreDecrease = settingsVC.decrease
        
        view.backgroundColor = settingsVC.fieldBackground
        cardViews.forEach { cardView in
            cardView.lineWidth = settingsVC.lineWidth ?? 5.0
        }
        cardViews.forEach { cardView in
            cardView.lines = settingsVC.lines ?? 12
        }
        cardViews.forEach { cardView in
            cardView.cardColor = settingsVC.cardColor ?? #colorLiteral(red: 0.8412953019, green: 0.2027314007, blue: 0.5099305511, alpha: 1)
        }
        cardViews.forEach { cardView in
            cardView.lineColor = settingsVC.lineColor ?? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }
    
    
    @IBAction func presentHighscoreView(_ sender: Any) {
        guard let highscoreVC = storyboard?.instantiateViewController(withIdentifier: "HighScoreViewControllerStoryboard") as? HighscoreViewController else{ return }
        highscoreVC.highscoreArray = scoreArray
    }
    
    
}



extension MatchingCardViewController: MatchingCardGameDelegate {

    func matchingCardGameScoreDidChange(to score: Int) {
        scoreLabel?.text = "Score: \(score)"
    
    }
    
    func addNewHighscore(to highscore: Int) {
        if highscore > 0{
            scoreArray.append(highscore)
        }
    }
    
   
    
    func matchingCardGameDidEnd(with cards: [Card]) {
        print("game over with cards: ", cards)
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0.0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 0.2,
            options: [],
            animations: {
                self.cardViews.forEach { $0.matched = true }
                
                self.restartButton?.isHidden = false
                self.restartButton?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            },
            completion: { _ in
                UIView.animate(withDuration: 0.5, animations: {
                    self.restartButton?.transform = .identity
                })
            }
        )
    }
}

extension MatchingCardViewController: DrawingCardViewDelegate {
    
    private func cardButton(matching card: Card) -> DrawingCardView {
        return cardViews.first(where: { (cardView: DrawingCardView) -> Bool in
            cardView.card == card
        })!
    }
    
    func drawingCardView(_ cardView: DrawingCardView, flippedWith card: Card?) {
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
        case .alreadySelected:
            UIView.animate(
                withDuration: 0.07,
                delay: 0.0,
                options: [.repeat, .autoreverse],
                animations: {
                    UIView.setAnimationRepeatCount(3)
                    cardView.frame.origin.x -= 5
                    cardView.frame.origin.x += 5
                },
                completion: nil
            )
        }
    }
}

