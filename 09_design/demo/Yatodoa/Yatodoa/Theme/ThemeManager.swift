//
//  ThemeManager.swift
//  Yatodoa
//
//  Created by Alex Dobrynin on 11.12.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation
import UIKit

fileprivate extension Theme {
    var tintColor: UIColor {
        switch self {
        case .default: return #colorLiteral(red: 0, green: 0.4799999893, blue: 1, alpha: 1)
        case .colorful: return #colorLiteral(red: 0.7099999785, green: 0.5899999738, blue: 0.4900000095, alpha: 1)
        }
    }
    
    // navigation
    
    var navigationBarBackgroundColor: UIColor? {
        switch self {
        case .default: return nil
        case .colorful: return #colorLiteral(red: 0.7099999785, green: 0.5899999738, blue: 0.4900000095, alpha: 1)
        }
    }
    
    var navigationBarTextColor: UIColor {
        switch self {
        case .default: return .black
        case .colorful: return .white
        }
    }
    
    var navigationBarTintColor: UIColor {
        switch self {
        case .default: return #colorLiteral(red: 0, green: 0.4799999893, blue: 1, alpha: 1)
        case .colorful: return .white
        }
    }
    
    var positiveColor: UIColor? {
        switch self {
        case .default: return nil
        case .colorful: return #colorLiteral(red: 0.5500000119, green: 0.6999999881, blue: 0.6000000238, alpha: 1)
        }
    }
    
    var secondaryTextColor: UIColor? {
        switch self {
        case .default: return nil
        case .colorful: return #colorLiteral(red: 0.9700000286, green: 0.6000000238, blue: 0.5299999714, alpha: 1)
        }
    }
    
    var labelColor: UIColor? {
        switch self {
        case .default: return nil
        case .colorful: return #colorLiteral(red: 0.7099999785, green: 0.5899999738, blue: 0.4900000095, alpha: 1)
        }
    }
    
    var checkboxStyle: CheckboxStyle {
        switch self {
        case .default: return CheckboxStyle(checkmarkColor: tintColor, borderColor: nil)
        case .colorful: return CheckboxStyle(checkmarkColor: tintColor, borderColor: #colorLiteral(red: 0.5500000119, green: 0.6999999881, blue: 0.6000000238, alpha: 1))
        }
    }
}

final class ThemeManager {
    private init() {}
    
    static var current: Theme = .default {
        didSet { apply(current) }
    }
    
    private static func apply(_ theme: Theme) {
        (UIApplication.shared.delegate as! AppDelegate).window?.tintColor = theme.tintColor
        
        // navigation
        UINavigationBar.appearance().barTintColor = theme.navigationBarBackgroundColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: theme.navigationBarTextColor]
        UINavigationBar.appearance().tintColor = theme.navigationBarTintColor

        // plus button contained in addTodoView
        UIButton.appearance(whenContainedInInstancesOf: [AddTodoView.self]).setTitleColor(theme.positiveColor, for: .normal)
        
        // TodoCell Tag Label
        UILabel.appearance(whenContainedInInstancesOf: [ToDoTableViewCell.self]).textColor = theme.secondaryTextColor
        
        // switch
        UISwitch.appearance().onTintColor = theme.positiveColor?.withAlphaComponent(0.5)
        UISwitch.appearance().thumbTintColor = theme.positiveColor
        
        // header footer view
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self, DetailTodoTableViewController.self]).textColor = theme.labelColor
        
        TDCheckbox.appearance().checkboxStyle = theme.checkboxStyle
    }
}
