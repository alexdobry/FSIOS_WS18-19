//
//  Todo+CoreDataClass.swift
//  Yatodoa
//
//  Created by Alex Dobrynin on 04.12.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//
//

import Foundation
import CoreData

public class Todo: NSManagedObject {
    
    static func create(task: String, in context: NSManagedObjectContext) {
        let todo = Todo(context: context)
        todo.task = task
        todo.complete(to: false)
        todo.favorite = false
        todo.created = Date()
        todo.id = UUID()
    }
    
    var joinedTags: [Tag] {
        return tags?.compactMap { $0 as? Tag } ?? []
    }
    
    var joinedTagTitles: [String] {
        return joinedTags.map { $0.title }
    }
}
