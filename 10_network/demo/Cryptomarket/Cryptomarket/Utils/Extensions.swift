//
//  Extensions.swift
//  Cryptomarket
//
//  Created by Alex on 05.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation
import UIKit

extension Sequence {
    
    func groupBy<K : Hashable>(key: (Self.Iterator.Element) -> K) -> [K: [Self.Iterator.Element]] {
        return Dictionary(grouping: self, by: key)
    }
}

extension Array {
    subscript (safe index: Int) -> Element? {
        return index < count ? self[index] : nil
    }
}

extension Date {
    
    func plus(hour: Int) -> Date {
        return addingTimeInterval(TimeInterval(hour * 3600))
    }
}

extension DateComponents {
    
    var string: String? {
        guard let month = self.month, let year = self.year, let day = self.day else { return nil }
        
        let calendar = Calendar.current
        let isOtherYear = year != calendar.component(.year, from: Date())
        let monthAndDayString = "\(day). \(calendar.monthSymbols[month - 1])"
        
        return isOtherYear ? "\(monthAndDayString) \(year)" : monthAndDayString
    }
}
