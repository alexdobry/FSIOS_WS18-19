//
//  DetailPhotoViewController.swift
//  Unsplashy
//
//  Created by Alex Dobrynin on 13.11.18.
//  Copyright © 2018 Alex Dobrynin. All rights reserved.
//

import UIKit

class DetailPhotoViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        photoImageView.image = image
        
        scrollView.contentSize = photoImageView.frame.size
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 5.0
        scrollView.delegate = self
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photoImageView
    }
}
