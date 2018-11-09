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
    var cardBackground: UIColor?
    var lineWidth: CGFloat?
    var lineColor: UIColor?
    var lineNumber: Int = 1
    
    @IBOutlet private weak var increaseStepper: UIStepper!
    @IBOutlet private weak var decreaseStepper: UIStepper!
    
    @IBOutlet private weak var increaseLabel: UILabel!
    @IBOutlet private weak var decreaseLabel: UILabel!
    
    @IBOutlet private weak var fieldBackgroundTextField: UITextField!
    @IBOutlet private weak var cardBackgroundTextField: UITextField!
    @IBOutlet private weak var lineWidthTextField: UITextField!
    @IBOutlet private weak var lineColorTextField: UITextField!
    @IBOutlet private weak var lineNumerTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        increaseStepper.value = Double(increase)
        decreaseStepper.value = Double(decrease)
        
        stepperDidChange(increaseStepper)
        stepperDidChange(decreaseStepper)
        
        fieldBackgroundTextField.delegate = self
        fieldBackgroundTextField.text = fieldBackground?.toHexString
        textFieldDidEndEditing(fieldBackgroundTextField)
        
        cardBackgroundTextField.delegate = self
        cardBackgroundTextField.text = cardBackground?.toHexString
        textFieldDidEndEditing(cardBackgroundTextField)
        
        lineWidthTextField.delegate = self
        lineWidthTextField.text = lineWidth?.description
        textFieldDidEndEditing(lineWidthTextField)
        
        lineColorTextField.delegate = self
        lineColorTextField.text = lineColor?.toHexString
        textFieldDidEndEditing(lineColorTextField)
        
        lineNumerTextField.delegate = self
        lineNumerTextField.text = String(lineNumber)
        textFieldDidEndEditing(lineNumerTextField)
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
            cardBackground = mcvc?.cardViews.first?.cardColor
            lineWidth = mcvc?.cardViews.first?.lineWidth
            lineColor = mcvc?.cardViews.first?.lineColor
            lineNumber = mcvc?.cardViews.first?.lines ?? 1
            
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
        case cardBackgroundTextField:
            mcvc?.cardViews.forEach{$0.cardColor = UIColor(hex: text)}
        case lineWidthTextField:
            if let f = Float(text) {
                let lineWidth = CGFloat(f)

                mcvc?.cardViews.forEach { $0.lineWidth = lineWidth }
            }
        case lineColorTextField:
            mcvc?.cardViews.forEach{$0.lineColor = UIColor(hex: text)}
        case lineNumerTextField:
            if let n = Int(text)  {
                mcvc?.cardViews.forEach{$0.lines = n}
            }
            
        case _: break
        }
    }
}
