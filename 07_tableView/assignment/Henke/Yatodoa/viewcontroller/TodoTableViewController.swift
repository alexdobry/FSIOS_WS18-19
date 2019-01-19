//
//  TodoTableViewController.swift
//  Yatodoa
//
//  Created by Alex Dobrynin on 27.11.18.
//  Copyright © 2018 Alex Dobrynin. All rights reserved.
//

import UIKit

class TodoTableViewController: UITableViewController {
    
    private struct Storyboard {
        static let DetailSegueIdentifier = "Show Detail"
    }
    
    
    
    var todos: [Todo] = []
    var todo: Todo!
    
    var isFavorite = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(
            UINib(nibName: TodoTableViewCell.NibName, bundle: nil),
            forCellReuseIdentifier: TodoTableViewCell.ReuseIdentifier
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTodo)
        )
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TodoTableViewCell.ReuseIdentifier, for: indexPath) as! TodoTableViewCell
        let todo = todos[indexPath.row]
        
        cell.todo = todo.task
        cell.completed = todo.completed
        cell.tags = todo.tags
        cell.delegate = self
        //cell.favorized = todo.favorite
        
        
        cell.accessoryType = .detailButton
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: Storyboard.DetailSegueIdentifier, sender: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    @objc func addTodo() {
        let alert = UIAlertController(title: "Create Todo", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "your todo..."
        }
        
        let addAction = UIAlertAction(title: "Create", style: .default) { _ in
            guard let text = alert.textFields?.first?.text, !text.isEmpty else { return }
            self.createTodo(with: text)
        }
        
        alert.addAction(addAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (_, _, completion) in
            self.deleteTodo(at: indexPath)
            completion(true)
        }
        
        let config = UISwipeActionsConfiguration(actions: [delete])
        config.performsFirstActionWithFullSwipe = true
        return config
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let FavTitle = isFavorite ? "unfavorize" : "favorize"
        let favorize = UIContextualAction(style: .normal, title: FavTitle) { (_, _, completion) in 
            self.favorizeTodo(at: indexPath)
            completion(true)
        }
        favorize.backgroundColor = .brown
        
        let config = UISwipeActionsConfiguration(actions: [favorize])
        config.performsFirstActionWithFullSwipe = true
        return config
    }
    
    private func createTodo(with text: String) {
        let todo = Todo(task: text)
        todos.append(todo) // update model
        
        let row = todos.count - 1
        let indexPath = IndexPath(row: row, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic) // update UI
    }
    
    private func deleteTodo(at indexPath: IndexPath) {
        todos.remove(at: indexPath.row) // update model
        tableView.deleteRows(at: [indexPath], with: .automatic) // update UI
    }
    
    private func favorizeTodo(at indexPath: IndexPath) {
       // todos.remove(at: indexPath.row) // update model
        //tableView.deleteRows(at: [indexPath], with: .automatic) // update UI
        if isFavorite == false {
            isFavorite = true
            todo?.favorite = true
        } else {
            isFavorite = false
            todo?.favorite = false
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.DetailSegueIdentifier {
            let detailVC = segue.destination as! DetailTodoTableViewController
            let indexPath = sender as! IndexPath
            let todo = todos[indexPath.row]
            
            detailVC.todo = todo
            detailVC.indexPath = indexPath
            detailVC.delegate = self
        }
    }
}

extension TodoTableViewController: TodoTableViewCellDelete {
    
    func todoCell(_ cell: TodoTableViewCell, wasCompleted completed: Bool) {
        let indexPath = tableView.indexPath(for: cell)!
        
        todos[indexPath.row].completed = completed // update model
        tableView.reloadRows(at: [indexPath], with: .automatic) // update ui
    }
    
    func todoCell(_ cell: TodoTableViewCell, updatedTodoWith task: String) {
        let indexPath = tableView.indexPath(for: cell)!
        
        todos[indexPath.row].task = task // update model
        tableView.reloadRows(at: [indexPath], with: .automatic) // update ui
    }
}

extension TodoTableViewController: DetailTodoTableViewControllerDelete {
    
    func detailVC(_ vc: DetailTodoTableViewController, deleted todo: Todo, at indexPath: IndexPath) {
        deleteTodo(at: indexPath)
    }

}

extension TodoTableViewController: DetailTodoTableViewControllerFavorize {
    func detailVC(_ vc: DetailTodoTableViewController, favorized todo: Todo, at indexPath: IndexPath) {
        //favorizeTodo(at: indexPath)
        
    }
}
