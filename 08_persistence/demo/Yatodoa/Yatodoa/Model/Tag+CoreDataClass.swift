//
//  Tag+CoreDataClass.swift
//  Yatodoa
//
//  Created by Alex Dobrynin on 04.12.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

public class Tag: NSManagedObject {

    var color: UIColor {
        get { return NSKeyedUnarchiver.unarchiveObject(with: color_ as! Data) as! UIColor }
        set { color_ = NSKeyedArchiver.archivedData(withRootObject: newValue) as NSObject }
    }
    
    static func populateIfNeeded(in context: NSManagedObjectContext) {
        let fr: NSFetchRequest<Tag> = Tag.fetchRequest()
        let count = try! context.count(for: fr)
        
        if count > 0 {
            print("there are \(count) tags already")
        } else {
            ["general", "shopping list", "study", "work", "yolo", "swag"].forEach { create(title: $0, in: context) }
        }
    }
    
    private static func create(title: String, in context: NSManagedObjectContext) {
        let tag = Tag(context: context)
        tag.title = title
        tag.color = UIColor.random
        tag.id = UUID()
    }
}
