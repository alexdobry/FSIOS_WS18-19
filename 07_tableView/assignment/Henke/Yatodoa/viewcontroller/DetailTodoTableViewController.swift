//
//  DetailTodoTableViewController.swift
//  Yatodoa
//
//  Created by Alex Dobrynin on 27.11.18.
//  Copyright © 2018 Alex Dobrynin. All rights reserved.
//

import UIKit

protocol DetailTodoTableViewControllerDelete {
    func detailVC(_ vc: DetailTodoTableViewController, deleted todo: Todo, at indexPath: IndexPath)
}


protocol DetailTodoTableViewControllerFavorize {
    func detailVC(_ vc: DetailTodoTableViewController, favorized todo: Todo, at indexPath: IndexPath)
}

class DetailTodoTableViewController: UITableViewController {
    
    var todo: Todo!
    var indexPath: IndexPath!
    
    var isFavorite : Bool!
    
    var delegate: DetailTodoTableViewControllerDelete?
    var delegateFav: DetailTodoTableViewControllerFavorize?

    @IBOutlet weak private var tagsLabel: UILabel!
    
    private var currentTags: [String] {
        get { return tagsLabel.text?.isEmpty ?? true ? [] : tagsLabel.text!.components(separatedBy: ", ") }
        set { tagsLabel.text = newValue.isEmpty ? nil : newValue.joined(separator: ", ") }
    }
    
    private var favImage: UIImage {
        get { return navigationItem.rightBarButtonItems!.last!.image! }
        set { navigationItem.rightBarButtonItems!.last!.image = newValue }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = todo.task
        currentTags = todo.tags
   
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteTodo)),
            UIBarButtonItem(image: todo.favorite ? #imageLiteral(resourceName: "fav") : #imageLiteral(resourceName: "unfav"), style: .plain, target: self, action: #selector(favorizeTodo))
        ]
        
        if todo.completed {
            navigationItem.rightBarButtonItems?.forEach { $0.isEnabled = false }
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let f = DateFormatter()
        f.dateStyle = .short
        f.timeStyle = .short
        
        if let finished = todo.finished, section == 1 {
            return "Erledigt am \(f.string(from: finished))"
        } else {
            return nil
        }
    }
    
    @objc func deleteTodo() {
        delegate?.detailVC(self, deleted: todo, at: indexPath)
        navigationController?.popViewController(animated: true)
    }

    @objc func favorizeTodo() {
        let isFav = favImage == #imageLiteral(resourceName: "fav")
        if isFav == true {
            todo.favorite = false
        } else {
            todo.favorite = true
        }
        
        
       favImage = isFav ? #imageLiteral(resourceName: "unfav") : #imageLiteral(resourceName: "fav")
        
        print(todo.favorite)
        
        //delegate?.detailVC(DetailTodoTableViewController, favorize: Todo, at: IndexPath)
        delegateFav?.detailVC(self, favorized: todo, at: indexPath)
        //func detailVC(_ vc: DetailTodoTableViewController, favorized todo: Todo, at indexPath: IndexPath)
        
        // FIXME: assignment
    }
}
