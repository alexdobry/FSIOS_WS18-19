import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

enum Result<T> {
    case success(T)
    case failure(Error)
}

struct Ressource<T> {
    let url: URL
    let parse: (Data) throws -> T
}

class Webservice {
    
    func get<T>(by ressource: Ressource<T>, completion: @escaping (Result<T>) -> Void) {
        let request = URLRequest(url: ressource.url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 5.0)
        let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
            let result: Result<T>
            
            if let networkError = error {
                result = .failure(networkError)
            } else if let data = data {
                do {
                    let t = try ressource.parse(data)
                    result = .success(t)
                } catch {
                    result = .failure(error)
                }
            } else {
                result = .failure(NSError(domain: "this should never happen", code: -1, userInfo: nil))
            }
            
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        task.resume()
    }
}

struct MarketSummaryJson: Codable {
    let success: Bool
    let summaries: [MarketSummary]
    
    enum CodingKeys: String, CodingKey {
        case success
        case summaries = "result"
    }
}

struct MarketSummary: Codable {
    let name: String
    let timestamp: Date
    let high: Double
    let last: Double
    let low: Double
    
    enum CodingKeys: String, CodingKey {
        case name = "MarketName"
        case timestamp = "TimeStamp"
        case high = "High"
        case last = "Last"
        case low = "Low"
    }
}

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


let ws = Webservice()

let marketRessource = Ressource<MarketJson>(url: URL(string: "https://api.bittrex.com/api/v1.1/public/getMarkets")!) { data -> MarketJson in
    let d = JSONDecoder()
    return try d.decode(MarketJson.self, from: data)
}

ws.get(by: marketRessource) { marketResult in
    switch marketResult {
    case .success(let marketJson):
        let ressources = marketJson.markets.map { market in
            return Ressource<MarketSummaryJson>(url: URL(string: "https://api.bittrex.com/api/v1.1/public/getmarketsummary?market=\(market.name)")!) { data -> MarketSummaryJson in
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                
                let d = JSONDecoder()
                d.dateDecodingStrategy = .formatted(formatter)
                
                return try d.decode(MarketSummaryJson.self, from: data)
            }
        }
        
        ressources.forEach { r in
            ws.get(by: r) { marketSummaryResult in
                switch marketSummaryResult {
                case .success(let summaryJson):
                    print(summaryJson.summaries.first!)
                case .failure(let error2):
                    print(error2)
                }
            }
        }
    case .failure(let error):
        print(error)
    }
}
