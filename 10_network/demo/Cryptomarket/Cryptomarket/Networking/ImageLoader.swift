//
//  ImageLoader.swift
//  Cryptomarket
//
//  Created by Alex Dobrynin on 08.01.19.
//  Copyright © 2019 Alexander Dobrynin. All rights reserved.
//

import Foundation
import UIKit

fileprivate extension URL {
    var nsString: NSString {
        return NSString(string: absoluteString)
    }
}

final class ImageLoader {
    
    static let shared = ImageLoader(cache: NSCache<NSString, UIImage>())
    
    private let cache: NSCache<NSString, UIImage>
    
    private init(cache: NSCache<NSString, UIImage>) {
        self.cache = cache
    }
    
    func image(by url: URL, completion: @escaping (UIImage?, URL) -> Void) {
        if let cached = cache.object(forKey: url.nsString) {
            completion(cached, url)
        } else {
            DispatchQueue.global(qos: .userInitiated).async {
                let data = try? Data.init(contentsOf: url)
                let img = data.flatMap(UIImage.init)
                
                DispatchQueue.main.async {
                    if let img = img {
                        self.cache.setObject(img, forKey: url.nsString)
                    } else {
                        self.cache.removeObject(forKey: url.nsString)
                    }
                    
                    completion(img, url)
                }
            }
        }
    }
}
