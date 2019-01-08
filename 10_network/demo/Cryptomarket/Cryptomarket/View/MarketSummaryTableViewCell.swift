//
//  MarketSummaryTableViewCell.swift
//  Cryptomarket
//
//  Created by Alex on 05.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit

class MarketSummaryTableViewCell: UITableViewCell {
    
    static let Identifier = "MarketSummaryTableViewCell"
    
    @IBOutlet private weak var timestamp: UILabel!
    @IBOutlet private weak var last: UILabel!
    @IBOutlet private weak var delta: UILabel!
    
    func configure(withCurrentValue value: Double, currency: String, delta: MarketSummaryDelta?, andTimestamp date: Date) {
        last.text = readableCurrency(of: value, basedOnCurrency: currency)
        timestamp.text = dateFormatter.string(from: date)
        
        if let delta = delta {
            switch delta.status {
            case .neutral:
                self.delta.textColor = .lightGray
                self.delta.text = "-"
            case .down:
                self.delta.textColor = #colorLiteral(red: 0.9700000286, green: 0.6000000238, blue: 0.5299999714, alpha: 1)
                self.delta.text = "\(readableCurrency(of: delta.value, basedOnCurrency: currency)) (\(readablePercentage(of: delta.percent)))"
            case .up:
                self.delta.textColor = #colorLiteral(red: 0.5500000119, green: 0.6999999881, blue: 0.6000000238, alpha: 1)
                self.delta.text = "\(readableCurrency(of: delta.value, basedOnCurrency: currency)) (\(readablePercentage(of: delta.percent)))"
            }
        } else {
            self.delta.textColor = .lightGray
            self.delta.text = "-"
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        last.text = nil
        timestamp.text = nil
        delta.textColor = nil
        delta.text = nil
    }
}
