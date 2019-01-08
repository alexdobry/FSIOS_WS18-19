//
//  Market.swift
//  Cryptomarket
//
//  Created by Alex on 05.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

struct MarketJson: Codable {
    let success: Bool
    let markets: [Market]
    
    enum CodingKeys: String, CodingKey {
        case success
        case markets = "result"
    }
}

struct Market: Codable {
    let baseCurrency: String
    let logoUrl: URL
    let currency: String
    let currencyLong: String
    let active: Bool
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case baseCurrency = "BaseCurrency"
        case logoUrl = "LogoUrl"
        case currency = "MarketCurrency"
        case currencyLong = "MarketCurrencyLong"
        case name = "MarketName"
        case active = "IsActive"
    }
}
