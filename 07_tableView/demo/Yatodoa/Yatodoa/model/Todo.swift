//
//  Todo.swift
//  Yatodoa
//
//  Created by Alex Dobrynin on 27.11.18.
//  Copyright © 2018 Alex Dobrynin. All rights reserved.
//

import Foundation

struct Todo {
    let id: UUID
    var task: String
    var favorite: Bool
    var tags: [String]
    
    var completed: Bool {
        didSet {
            finished = completed ? Date() : nil
        }
    }
    
    private(set) var finished: Date?
    
    private init(task: String, completed: Bool, favorite: Bool, tags: [String]) {
        self.id = UUID()
        self.task = task
        self.completed = completed
        self.favorite = favorite
        self.tags = tags
    }
    
    init(task: String) {
        self.init(task: task, completed: false, favorite: false, tags: [])
    }
}
