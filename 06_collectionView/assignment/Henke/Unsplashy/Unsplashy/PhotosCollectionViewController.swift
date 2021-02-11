//
//  PhotosCollectionViewController.swift
//  Unsplashy
//
//  Created by Alex Dobrynin on 13.11.18.
//  Copyright © 2018 Alex Dobrynin. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class PhotosCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIViewControllerPreviewingDelegate, PhotoCollectionViewCellDelegate {
    
    @IBOutlet weak var zoomInButton: UIBarButtonItem!
    @IBOutlet weak var zoomOutButton: UIBarButtonItem!
    
    
    private var urls: [URL] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        urls = (1...37)
            .map { "http://www.gm.fh-koeln.de/~dobrynin/fsios/images/\($0).jpeg" }
            .compactMap { URL(string: $0) }
        
        registerForPreviewing(with: self, sourceView: collectionView)
        
        navigationItem.leftBarButtonItem = editButtonItem
        
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "DetailPhotoViewControllerID") as? DetailPhotoViewController,
            let cell = collectionView.cellForItem(at: indexPath) as? PhotoCollectionViewCell,
            let image = cell.image
            else {
                return
        }
        
        vc.image = image
        vc.preferredContentSize = image.size
        
        //present(vc, animated: true, completion: nil)
        navigationController!.pushViewController(vc, animated: true)

    }
    
    
    // MARK: UICollectionViewDataSource


    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return model.isEmpty ? 0 : 1
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return section == 0 ? model.count : 0
        return urls.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCollectionViewCell
        let url = urls[indexPath.row]
        cell.url = url
        cell.isEditing = isEditing
        cell.delegate = self
        return cell
    }

    // MARK: UICollectionViewDelegateFlowLayout
    
    private let itemSpacing: CGFloat = 3
    private let sectionSpacing: CGFloat = 3
    
    private var itemsInLine: CGFloat = 3 {
        didSet{
            let layout = UICollectionViewFlowLayout()
            collectionView.setCollectionViewLayout(layout, animated: true)
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthWithoutSpacing = collectionView.frame.width - (itemSpacing * (itemsInLine - 1))
        let a = widthWithoutSpacing / itemsInLine
        
        return CGSize(width: a, height: a)
    }
    
    // MARK: UIViewControllerPreviewingDelegate

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "DetailPhotoViewControllerID") as? DetailPhotoViewController,
            let indexPath = collectionView.indexPathForItem(at: location),
            let cell = collectionView.cellForItem(at: indexPath) as? PhotoCollectionViewCell,
            let image = cell.image

        else { return nil }
        
        vc.image = image
        vc.preferredContentSize = image.size
        previewingContext.sourceRect = cell.frame
        
        return vc
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
    
    // MARK: Editing
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        zoomInButton.isEnabled = false
        zoomOutButton.isEnabled = false
        super.setEditing(editing, animated: animated)
        
        
        collectionView.visibleCells.forEach { cell in
            let photoCell = cell as! PhotoCollectionViewCell
            photoCell.isEditing = editing
            photoCell.delegate = editing ? self : nil
        }
        if isEditing == false {
            zoomInButton.isEnabled = true
            zoomOutButton.isEnabled = true
        }
    }
    
    func deleteButtonWasTapped(on cell: PhotoCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        
        
        urls.remove(at: indexPath.row)
        collectionView.deleteItems(at: [indexPath])
    }
    
    //collectionView.indexPathForVisibleItems
    
    @IBAction func zoomInOnPhotos(_ button: UIBarButtonItem) {
        if(itemsInLine > 1){
            itemsInLine -= 1
        }
    }
    
    
    @IBAction func zoomOutOfPhotos(_ button: UIBarButtonItem) {
        if(itemsInLine < 6){
            itemsInLine += 1
        }
    }
    
}
