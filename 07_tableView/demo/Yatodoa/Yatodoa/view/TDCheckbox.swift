//
//  TDCheckbox.swift
//  Yatodoa
//
//  Created by Alex Dobrynin on 27.11.18.
//  Copyright © 2018 Alex Dobrynin. All rights reserved.
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
