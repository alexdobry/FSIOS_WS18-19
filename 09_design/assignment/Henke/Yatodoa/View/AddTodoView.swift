//
//  AddTodoView.swift
//  Yatodoa
//
//  Created by Alex Dobrynin on 11.12.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit

protocol AddTodoViewDelegate {
    func addTodoView(_ view: AddTodoView, didCreateTodo task: String)
}

class AddTodoView: CustomView {

    @IBOutlet weak private var textField: UITextField! {
        didSet { textField.delegate = self }
    }
    
    var delegate: AddTodoViewDelegate?
    
    @IBOutlet weak var plusButtonHeight: NSLayoutConstraint!
    
    var preferedMinimumHeight: CGFloat {
        return plusButtonHeight.constant + 2 * 8
    }
}

extension AddTodoView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if let text = textField.text, !text.isEmpty {
            delegate?.addTodoView(self, didCreateTodo: text)
            textField.text = nil
        }
        
        return true
    }
}
