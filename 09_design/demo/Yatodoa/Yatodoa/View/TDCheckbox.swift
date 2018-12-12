//
//  TDCheckbox.swift
//  Done
//
//  Created by Alex on 16.10.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import UIKit

class CheckboxStyle: NSObject {
    let checkmarkColor: UIColor // default: .black, colorful: .green
    let borderColor: UIColor? // default: nil, colorful: .green circle
    
    init(checkmarkColor: UIColor, borderColor: UIColor?) {
        self.checkmarkColor = checkmarkColor
        self.borderColor = borderColor
    }
}

@IBDesignable
class TDCheckbox: UIButton {
    
    @IBInspectable
    var checked: Bool {
        get { return title(for: .normal) != nil }
        set { setTitle(newValue ? "✓" : nil, for: .normal) }
    }
    
    @objc dynamic var checkboxStyle: CheckboxStyle? {
        didSet {
            guard let checkboxStyle = checkboxStyle else { return }
            
            setTitleColor(checkboxStyle.checkmarkColor, for: .normal)
            
            if let border = checkboxStyle.borderColor { // circle
                backgroundColor = nil
                
                layer.borderWidth = 2.0
                layer.cornerRadius = 30 / 2
                layer.borderColor = border.cgColor
            } else { // rectangle
                backgroundColor = .lightGray
                
                layer.borderWidth = 0
                layer.cornerRadius = 0
                layer.borderColor = nil
            }
        }
    }
}
