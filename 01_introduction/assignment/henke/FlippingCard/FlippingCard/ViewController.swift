//
//  ViewController.swift
//  FlippingCard
//
//  Created by Student on 09.10.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    
    
    
    var count = 0 { // model <-> ui
        didSet {
            counterLabel.text = "Counter: \(count)"
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let right = UISwipeGestureRecognizer(target: self, action: #selector(flipRight(_:)))
        right.direction = .right
        
        let left = UISwipeGestureRecognizer(target: self, action: #selector(flipLeft(_:)))
        left.direction = .left
      
       
        
        button1.addGestureRecognizer(right)
        button2.addGestureRecognizer(left)
        // button3.addGestureRecognizer(right)
       // button4.addGestureRecognizer(right)
    }
    
    
    @objc func flipRight(_ sender: UISwipeGestureRecognizer) {
        let button = sender.view as! UIButton
        
        if button.currentTitle == "Swipe Right" {
            button.setTitle("Swipe Right", for: .normal)
            button.setBackgroundImage(#imageLiteral(resourceName: "card_front"), for: .normal)
        } else {
            switchButton(button, to: "Swipe Right")
        }

    }
    
    @objc func flipLeft(_ sender: UISwipeGestureRecognizer) {
        let button = sender.view as! UIButton
        
        if button.currentTitle == "Swipe Left" {
            button.setTitle("Swipe Left", for: .normal)
            button.setBackgroundImage(#imageLiteral(resourceName: "card_front"), for: .normal)
        } else {
            switchButton(button, to: "Swipe Left")
        }
        
    }
    
    @IBAction func flipCard(_ sender: UIButton) {
        switchButton(sender, to: "Tapped")
    }
    
    func flipButtonsToBack(_ button: UIButton) {
        if button.currentTitle != nil{
            button.setBackgroundImage(#imageLiteral(resourceName: "card_back"), for: .normal)
            button.setTitle(nil, for: .normal)
        }
    }

    
    func switchButton(_ button: UIButton, to text: String) {
        if button.currentTitle == nil {
            // back
            button.setBackgroundImage(#imageLiteral(resourceName: "card_front"), for: .normal)
            button.setTitle(text, for: .normal)
        } else {
            // front
            button.setBackgroundImage(#imageLiteral(resourceName: "card_back"), for: .normal)
            button.setTitle(nil, for: .normal)
        }
        
        count += 1
    }
    
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        count=0
        flipButtonsToBack(button1)
        flipButtonsToBack(button2)
        flipButtonsToBack(button3)
        flipButtonsToBack(button4)
        
    }
}

