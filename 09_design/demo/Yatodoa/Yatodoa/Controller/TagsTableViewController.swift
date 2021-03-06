//
//  TagsTableViewController.swift
//  Yatodoa
//
//  Created by Alex on 04.12.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import UIKit
import CoreData

protocol TagsTableViewControllerDelegate {
    func updateTags()
}

class TagsTableViewController: NSFetchedResultsTableViewController {
    
    // MARK: public api
    var viewContext: NSManagedObjectContext!
    var todo: Todo!
    
    var delegate: TagsTableViewControllerDelegate?
    
    lazy var fetchedResultsController: NSFetchedResultsController<Tag> = {
        let fr: NSFetchRequest<Tag> = Tag.fetchRequest()
        fr.sortDescriptors = []
        
        let fc = NSFetchedResultsController(
            fetchRequest: fr,
            managedObjectContext: viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        fc.delegate = self
        
        return fc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Taggen"
        try! fetchedResultsController.performFetch()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections!.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections![section].numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TagCellReuseIdentifier", for: indexPath)
        let tag = fetchedResultsController.object(at: indexPath)
        
        cell.textLabel?.text = tag.title
        cell.textLabel?.textColor = tag.uiColor

        if todo.joinedTags.contains(tag) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selected = fetchedResultsController.object(at: indexPath)
        
        if todo.joinedTags.contains(selected) {
            todo.removeFromTags(selected)
        } else {
            todo.addToTags(selected)
        }
        
        delegate?.updateTags()
    }
}
