//
//  ScoreViewController.swift
//  MatchingCardGame
//




import UIKit

class ScoreViewController: UIViewController {
    
    var scores: [Int] = []

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(scores)

        
    }
    
    
    @IBAction func dismiss(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        writeHighScore()
    }
    
    func writeHighScore(){
        
        var text = ""
        
        scores.forEach { print($0)
            
            text = text + "\($0) Points \n"
        }
        print(text)
        scoreLabel.text = text
    }
}
