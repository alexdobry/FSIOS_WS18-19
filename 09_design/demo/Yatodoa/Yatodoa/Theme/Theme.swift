//
//  Theme.swift
//  Yatodoa
//
//  Created by Alex Dobrynin on 11.12.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

enum Theme: Int, CaseIterable {
    case `default`, colorful
    
    var title: String {
        switch self {
        case .default: return "Standard"
        case .colorful: return "Farbenfroh"
        }
    }
}
