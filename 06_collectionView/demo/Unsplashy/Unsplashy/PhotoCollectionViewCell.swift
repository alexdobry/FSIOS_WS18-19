//
//  PhotoCollectionViewCell.swift
//  Unsplashy
//
//  Created by Alex Dobrynin on 13.11.18.
//  Copyright © 2018 Alex Dobrynin. All rights reserved.
//

import UIKit

protocol PhotoCollectionViewCellDelegate {
    func deleteButtonWasTapped(on cell: PhotoCollectionViewCell)
}

class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var deletionView: UIVisualEffectView! {
        didSet {
            deletionView.layer.cornerRadius = deletionView.bounds.width / 2
            deletionView.layer.masksToBounds = true
        }
    }
    
    var delegate: PhotoCollectionViewCellDelegate?
    
    var url: URL? {
        didSet { updateUI() }
    }
    
    var isEditing: Bool = false {
        didSet { deletionView.isHidden = !isEditing }
    }
    
    var image: UIImage? {
        return photoImageView.image
    }
    
    private var cookieUrl: URL?
    
    private func updateUI() {
        guard let url = url else { return }
        
        cookieUrl = url
        
        ImageLoader.default.image(by: url) { image in
            if self.cookieUrl == url {
                self.photoImageView.image = image
            }
        }
    }
    
    @IBAction func deleteCell(_ sender: Any) {
        delegate?.deleteButtonWasTapped(on: self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        photoImageView.image = nil
        cookieUrl = nil
        isEditing = false
    }
}
