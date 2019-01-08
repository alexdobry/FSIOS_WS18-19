//
//  MarketService.swift
//  Cryptomarket
//
//  Created by Alex on 05.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

final class MarketService {
    
    static func `default`() -> MarketService {
        return MarketService(
            webservice: Webservice(),
            ressource: Ressource<MarketJson>(url: URL(string: "\(NetworkingConstants.BaseURL)/getMarkets")!) { data -> MarketJson in
                return try JSONDecoder().decode(MarketJson.self, from: data)
            }
        )
    }
    
    private let webservice: Webservice
    private let ressource: Ressource<MarketJson>
    
    private init(webservice: Webservice, ressource: Ressource<MarketJson>) {
        self.webservice = webservice
        self.ressource = ressource
    }
    
    func markets(completion: @escaping (Result<[Market]>) -> Void) {
        webservice.get(by: ressource) { result in
            completion(result.map { $0.markets })
        }
    }
}
