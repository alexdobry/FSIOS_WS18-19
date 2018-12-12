//
//  TodoTableViewController.swift
//  Done
//
//  Created by Alex on 26.10.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import UIKit
import CoreData

class TodoTableViewController: NSFetchedResultsTableViewController {
    
    enum Predicate: String {
        case all = "All", open = "Open"
        
        var next: Predicate {
            switch self {
            case .open: return .all
            case .all: return .open
            }
        }
    }
    
    private struct Storyboard {
        static let DetailSegueIdentifier = "TodoDetailSegue"
    }
    
    var viewContext: NSManagedObjectContext = AppDelegate.viewContext
    
    lazy var fetchedResultsController: NSFetchedResultsController<Todo> = {
        let fr: NSFetchRequest<Todo> = Todo.fetchRequest()
        fr.sortDescriptors = [NSSortDescriptor(keyPath: \Todo.created, ascending: true)]
        
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
    
        tableView.register(
            UINib(nibName: ToDoTableViewCell.NibName, bundle: nil),
            forCellReuseIdentifier: ToDoTableViewCell.ReuseIdentifier
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: Predicate.all.rawValue,
            style: .plain,
            target: self,
            action: #selector(changePredicate(_:))
        )
        
        try! fetchedResultsController.performFetch()
        
        tableView.tableHeaderView = makeAddTodoView()
        tableView.tableHeaderView?.dropShadow()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections!.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections![section].numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ToDoTableViewCell.ReuseIdentifier, for: indexPath) as! ToDoTableViewCell
        let todo = fetchedResultsController.object(at: indexPath)

        cell.delegate = self
        cell.todo = todo.task
        cell.completed = todo.completed
        cell.tags = todo.joinedTagTitles
        cell.favorized = todo.favorite
        
        cell.accessoryType = .detailButton
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: Storyboard.DetailSegueIdentifier, sender: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (_, _, completion) in
            self.delete(at: indexPath)
            completion(true)
        }
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let title = fetchedResultsController.object(at: indexPath).favorite ? "Unfav" : "Fav"
        let favorize = UIContextualAction(style: .normal, title: title) { (_, _, completion) in
            self.favorize(at: indexPath)
            completion(true)
        }
        
        favorize.backgroundColor = #colorLiteral(red: 0.8078431373, green: 0.7764705882, blue: 0.2941176471, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [favorize])
    }
    
    // MARK: - navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case Storyboard.DetailSegueIdentifier:
            
            let nav = segue.destination as! UINavigationController
            let dvc = nav.topViewController as! DetailTodoTableViewController
            let indexPath = sender as! IndexPath
            
            dvc.indexPath = indexPath
            dvc.todo = fetchedResultsController.object(at: indexPath)
            dvc.viewContext = viewContext
            
        default: break
        }
    }
    
    @objc func changePredicate(_ sender: UIBarButtonItem) {
        let next = sender.title.flatMap(Predicate.init)!.next
        
        navigationItem.rightBarButtonItem?.title = next.rawValue
        
        let predicate: NSPredicate?
        
        switch next {
        case .all: predicate = nil
        case .open: predicate = NSPredicate(format: "completed == %@", NSNumber(value: false))
        }
        
        fetchedResultsController.fetchRequest.predicate = predicate
        try! fetchedResultsController.performFetch()
        tableView.reloadData()
    }
    
    private func delete(at indexPath: IndexPath) {
        let todo = fetchedResultsController.object(at: indexPath)
        viewContext.delete(todo)
    }
    
    private func favorize(at indexPath: IndexPath) {
        fetchedResultsController.object(at: indexPath).favorite.toggle()
    }
    
    private func makeAddTodoView() -> AddTodoView {
        let view = AddTodoView()
        let minHeight = view.preferedMinimumHeight
        
        view.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: minHeight * 1.2)
        view.delegate = self
        return view
    }
}

// MARK: ToDoTableViewCellDelegate

extension TodoTableViewController: ToDoTableViewCellDelegate {
    
    func todoCell(_ cell: ToDoTableViewCell, wasCompleted completed: Bool) {
        let indexPath = tableView.indexPath(for: cell)!
        
        fetchedResultsController.object(at: indexPath).complete(to: completed)
    }
    
    func todoCell(_ cell: ToDoTableViewCell, updatedTodo task: String) {
        let indexPath = tableView.indexPath(for: cell)!
        
        fetchedResultsController.object(at: indexPath).task = task
    }
}

extension TodoTableViewController: AddTodoViewDelegate {
    func addTodoView(_ view: AddTodoView, didCreateTodo task: String) {
        _ = Todo.create(task: task, in: viewContext)
    }
}
