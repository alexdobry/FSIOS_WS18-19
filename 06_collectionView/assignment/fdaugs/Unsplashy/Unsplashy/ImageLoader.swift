//
//  ImageLoader.swift
//  Unsplashy
//
//  Created by Alex Dobrynin on 13.11.18.
//  Copyright © 2018 Alex Dobrynin. All rights reserved.
//

import UIKit

class ImageLoader {
    
    static let `default` = ImageLoader()
    let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func image(by url: URL, completion: @escaping (UIImage?) -> Void) {
        if let image = cache.object(forKey: url.description as NSString) {
            completion(image)
        } else {
            DispatchQueue.global(qos: .userInitiated).async {
                let data = try? Data(contentsOf: url)
                let image = data.flatMap(UIImage.init)
                
                DispatchQueue.main.async {
                    if (image != nil) {
                        self.cache.setObject(image!, forKey: url.description as NSString)
                    }
                    completion(image)
                }
            }
        }
    }
}
