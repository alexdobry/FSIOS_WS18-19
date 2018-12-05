//
//  ToDo.swift
//  Done
//
//  Created by Alex on 13.10.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import Foundation

//struct Todo: CustomStringConvertible {
//    var created: Date
//    var task: String
//    var favorite: Bool
//    var tags: [String]
//
//    var completed: Bool {
//        didSet { finished = completed ? Date() :  nil }
//    }
//
//    private(set) var finished: Date?
//    private(set) var id: UUID
//
//    private init(task: String, completed: Bool, favorite: Bool, tags: [String]) {
//        self.id = UUID()
//        self.created = Date()
//        self.task = task
//        self.completed = completed
//        self.favorite = favorite
//        self.finished = completed ? Date() :  nil
//        self.tags = tags
//    }
//
//    init (task: String) {
//        self.init(task: task, completed: false, favorite: false, tags: [])
//    }
//
//    var description: String {
//        return "task: \(task), completed: \(completed), favorite: \(favorite)"
//    }
//}
//
//extension Todo: Equatable {
//
//    static func ==(lhs: Todo, rhs: Todo) -> Bool {
//        return lhs.id == rhs.id
//    }
//}
