//
//  DetailTodoTableViewController.swift
//  Yatodoa
//
//  Created by Alex on 27.11.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import UIKit
import CoreData

class DetailTodoTableViewController: UITableViewController {
    
    private struct Constants {
        static let Formatter: DateFormatter = {
            let f = DateFormatter()
            f.dateStyle = .short
            f.timeStyle = .short
            return f
        }()
        
        static let TagSegue = "TagSelectionSegue"
    }
    
    // MARK: 1. preparation
    var viewContext: NSManagedObjectContext!
    var todo: Todo!
    var indexPath: IndexPath!
    
    // MARK: 2. Outlets
    @IBOutlet weak private var tagLabel: UILabel!
    
    var favImage: UIImage {
        set { navigationItem.rightBarButtonItems!.last!.image = newValue }
        get { return navigationItem.rightBarButtonItems!.last!.image! }
    }
    
    private var currentTags: [String] {
        get { return tagLabel.text?.isEmpty ?? true ? [] : tagLabel.text!.components(separatedBy: ", ") }
        set { tagLabel.text = newValue.isEmpty ? nil : newValue.joined(separator: ", ") }
    }
    
    // MARK: 3. VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = todo.task
        currentTags = todo.joinedTagTitles
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteTodo)),
            UIBarButtonItem(image: todo.favorite ? #imageLiteral(resourceName: "fav") : #imageLiteral(resourceName: "unfav"), style: .plain, target: self, action: #selector(favorizeTodo))
        ]
        
        if todo!.completed {
            navigationItem.rightBarButtonItems?.forEach { $0.isEnabled = false }
        }
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if let finished = todo.finished, section == 1 {
            return "Erledigt am \(Constants.Formatter.string(from: finished))"
        } else {
            return nil
        }
    }
    
    @objc func deleteTodo() {
        viewContext.delete(todo)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func favorizeTodo() {
        let isFav = favImage == #imageLiteral(resourceName: "fav")
        favImage = isFav ? #imageLiteral(resourceName: "unfav") : #imageLiteral(resourceName: "fav")
        
        todo.favorite.toggle()
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case Constants.TagSegue:
            guard let destination = segue.destination as? TagsTableViewController else { return }
            
            destination.delegate = self
            destination.todo = todo
            destination.viewContext = viewContext
            
        default: break
        }
    }
}

extension DetailTodoTableViewController: TagsTableViewControllerDelegate {
    
    func tagsViewController(_ viewController: TagsTableViewController, updatedTags tags: [String]) {
        currentTags = tags
    }
}
