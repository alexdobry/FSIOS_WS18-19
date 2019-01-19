//
//  SettingsTableViewController.swift
//  Yatodoa
//
//  Created by Alex Dobrynin on 11.12.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var themeControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        themeControl.removeAllSegments()
        
        Theme.allCases.forEach { theme in
            themeControl.insertSegment(withTitle: theme.title, at: theme.rawValue, animated: true)
        }
        
        themeControl.selectedSegmentIndex = ThemeManager.current.rawValue
        selectedTheme(themeControl)
    }
    
    @IBAction func dismiss(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectedTheme(_ sender: UISegmentedControl) {
        guard let theme = Theme(rawValue: sender.selectedSegmentIndex) else { return }
        let window = (UIApplication.shared.delegate as! AppDelegate).window!
        
        UIView.animate(withDuration: 0.8) {
            ThemeManager.current = theme
            
            window.subviews.forEach {
                $0.removeFromSuperview()
                window.addSubview($0)
            }
        }
    }
}
