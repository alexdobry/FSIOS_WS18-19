//
//  HighscoreViewController.swift
//  MatchingCardGame
//
//  Created by Sabine Henke on 09.11.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation
import UIKit

class HighscoreViewController: UIViewController {
    
    @IBOutlet weak var highScoreText: UILabel!
    
    var highscoreArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        highScoreText.text = highscoreArray.map { "\($0)" }.joined(separator:"\n")
    }
    
    @IBAction func backButton(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}

