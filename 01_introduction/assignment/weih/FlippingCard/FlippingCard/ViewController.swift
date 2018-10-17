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
    
    var count = 0 { // model <-> ui
        didSet {
            counterLabel.text = "Counter: \(count)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let right = UISwipeGestureRecognizer(target: self, action: #selector(flipRight(_:)))
        right.direction = .right
        button1.addGestureRecognizer(right)
        // button2.addGestureRecognizer(right)
    }
    
    @objc func flipRight(_ sender: UISwipeGestureRecognizer) {
        let button = sender.view as! UIButton
        
        switchButton(button, to: "Swipe Right")
    }
    
    @IBAction func flipCard(_ sender: UIButton) {
        switchButton(sender, to: "Tapped")
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
}

