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
    
    @IBOutlet weak var highscoreText: UILabel!
    var highscoreArray: [Int] = []
    
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
 
    }
    
    @IBAction func BacktoGame(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)

    }
   
}
