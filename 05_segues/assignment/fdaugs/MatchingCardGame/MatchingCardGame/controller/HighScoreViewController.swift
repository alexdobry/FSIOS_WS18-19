//
//  HighScoreViewController.swift
//  MatchingCardGame
//
//  Created by Fabian Daugs on 10.11.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit

class HighScoreViewController: UIViewController {
    
    var highscore: [String: Int] = [:]
    
    @IBOutlet weak var highScoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        writeHighScore()
    }
    
    func writeHighScore(){
        var text = ""
        let highScoreSorted = highscore.sorted { $0.1 > $1.1 }
        highScoreSorted.forEach{
            print($0.key)
            text = text + "\($0.key): \($0.value) Points \n"
        }
        highScoreLabel.text = text
    }
    
    @IBAction func back(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
