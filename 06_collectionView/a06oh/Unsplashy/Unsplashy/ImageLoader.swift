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
    
    private init() {}
    
    func image(by url: URL, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let data = try? Data(contentsOf: url)
            let image = data.flatMap(UIImage.init)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
}
