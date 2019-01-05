//
//  TDCheckbox.swift
//  Done
//
//  Created by Alex on 16.10.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import UIKit

@IBDesignable
class TDCheckbox: UIButton {
    
    @IBInspectable
    var checked: Bool {
        get { return title(for: .normal) != nil }
        set { setTitle(newValue ? "✓" : nil, for: .normal) }
    }
}
