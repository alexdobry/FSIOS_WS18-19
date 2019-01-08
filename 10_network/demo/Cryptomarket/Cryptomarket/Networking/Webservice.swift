//
//  Webservice.swift
//  Cryptomarket
//
//  Created by Alex Dobrynin on 08.01.19.
//  Copyright © 2019 Alexander Dobrynin. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
    
    func map<U>(f: (T) -> U) -> Result<U> {
        switch self {
        case .success(let t): return .success(f(t))
        case .failure(let e): return .failure(e)
        }
    }
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
