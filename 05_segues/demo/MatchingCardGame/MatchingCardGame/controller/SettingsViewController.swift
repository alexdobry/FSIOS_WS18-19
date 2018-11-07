//
//  SettingsViewController.swift
//  MatchingCardGame
//
//  Created by Alex Dobrynin on 06.11.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
    
    var toHexString: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return String(
            format: "%02X%02X%02X",
            Int(r * 0xff),
            Int(g * 0xff),
            Int(b * 0xff)
        )
    }
}

class SettingsViewController: UIViewController {
    
    private struct Storyboard {
        static let UnwindIdentifier = "UnwindSegue"
        static let EmbedIdentifier = "EmbedSegue"
    }
    
    var increase: Int = 0
    var decrease: Int = 0
    var fieldBackground: UIColor?
    var lineWidth: CGFloat?
    
    @IBOutlet private weak var increaseStepper: UIStepper!
    @IBOutlet private weak var decreaseStepper: UIStepper!
    
    @IBOutlet private weak var increaseLabel: UILabel!
    @IBOutlet private weak var decreaseLabel: UILabel!
    
    @IBOutlet private weak var fieldBackgroundTextField: UITextField!
    @IBOutlet private weak var lineWidthTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        increaseStepper.value = Double(increase)
        decreaseStepper.value = Double(decrease)
        
        stepperDidChange(increaseStepper)
        stepperDidChange(decreaseStepper)
        
        fieldBackgroundTextField.delegate = self
        fieldBackgroundTextField.text = fieldBackground?.toHexString
        textFieldDidEndEditing(fieldBackgroundTextField)
        
        lineWidthTextField.delegate = self
        lineWidthTextField.text = lineWidth?.description
        textFieldDidEndEditing(lineWidthTextField)
    }

    @IBAction func done(_ sender: Any) {
        performSegue(withIdentifier: Storyboard.UnwindIdentifier, sender: self)
    }
    
    @IBAction func dismiss(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func stepperDidChange(_ sender: UIStepper) {
        switch sender {
        case increaseStepper:
            increaseLabel.text = "Increase Score by \(Int(sender.value))"
        case decreaseStepper:
            decreaseLabel.text = "Decrease Score by \(Int(sender.value))"
        case _: break
        }
    }
    
    var mcvc: MatchingCardViewController?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifer = segue.identifier else { return }
        
        switch identifer {
        case Storyboard.UnwindIdentifier:
            increase = Int(increaseStepper.value)
            decrease = Int(decreaseStepper.value)
            fieldBackground = mcvc?.view.backgroundColor
            lineWidth = mcvc?.cardViews.first?.lineWidth
            
        case Storyboard.EmbedIdentifier:
            mcvc = segue.destination as? MatchingCardViewController
            
        case _: break
        }
    }
}

extension SettingsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, !text.isEmpty else { return }
        
        switch textField {
        case fieldBackgroundTextField:
            mcvc?.view.backgroundColor = UIColor(hex: text)
        case lineWidthTextField:
            if let f = Float(text) {
                let lineWidth = CGFloat(f)

                mcvc?.cardViews.forEach { $0.lineWidth = lineWidth }
            }
            
            
        case _: break
        }
    }
}
