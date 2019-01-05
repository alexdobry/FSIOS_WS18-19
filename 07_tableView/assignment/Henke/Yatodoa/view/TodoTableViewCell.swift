//
//  TodoTableViewCell.swift
//  Yatodoa
//
//  Created by Alex Dobrynin on 27.11.18.
//  Copyright © 2018 Alex Dobrynin. All rights reserved.
//

import UIKit

protocol TodoTableViewCellDelete {
    func todoCell(_ cell: TodoTableViewCell, wasCompleted completed: Bool)
    func todoCell(_ cell: TodoTableViewCell, updatedTodoWith task: String)
}

class TodoTableViewCell: UITableViewCell {
    
    static let ReuseIdentifier = "TodoTableViewCell"
    static let NibName = "TodoTableViewCell"

    @IBOutlet weak private var todoTextField: UITextField! {
        didSet { todoTextField.delegate = self }
    }
    
    @IBOutlet weak private var outerStackView: UIStackView!
    @IBOutlet weak private var todoCheckbox: TDCheckbox!
    @IBOutlet weak private var tagsLabel: UILabel!
    @IBOutlet weak private var favoriteImage: UIImageView!
    
    
    
    var delegate: TodoTableViewCellDelete?
    
    var todo: String? {
        get { return todoTextField.text }
        set { todoTextField.text = newValue }
    }
    
    var completed: Bool {
        get { return todoCheckbox.checked }
        set {
            todoCheckbox.checked = newValue
            todoTextField.isUserInteractionEnabled = !newValue
            
            if let todo = todo {
                let foregroundColor: UIColor = completed ? .lightGray : .black
                let strikethroughStyle: NSUnderlineStyle = completed ? .single : []
                
                todoTextField.attributedText = NSAttributedString(string: todo, attributes: [
                    NSAttributedString.Key.foregroundColor : foregroundColor,
                    NSAttributedString.Key.strikethroughStyle: strikethroughStyle.rawValue
                ])
            } else {
                todoTextField.attributedText = nil
            }   
        }
    }
    
    var tags: [String] {
        get {
            return tagsLabel.text?.components(separatedBy: ", ") ?? []
        }
        set {
            if !newValue.isEmpty {
                outerStackView.addArrangedSubview(tagsLabel)
                tagsLabel.text = newValue.joined(separator: ", ")
            } else {
                tagsLabel.text = nil
                outerStackView.removeArrangedSubview(tagsLabel)
            }
        }
    }
    
    @IBAction func checkboxTapped(_ sender: TDCheckbox) {
        if let todo = todo, !todo.isEmpty {
            delegate?.todoCell(self, wasCompleted: !completed)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        todo = nil
        completed = false
        tags = []
    }
}

extension TodoTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if let todo = todo, !todo.isEmpty {
            delegate?.todoCell(self, updatedTodoWith: todo)
        }
        
        return true
    }
}
