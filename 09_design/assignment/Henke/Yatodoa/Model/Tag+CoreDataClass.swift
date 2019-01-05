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

    var uiColor: UIColor {
        get { return NSKeyedUnarchiver.unarchiveObject(with: color as! Data) as! UIColor }
        set { color = NSKeyedArchiver.archivedData(withRootObject: newValue) as NSObject }
    }
    
    static func populateIfNeeded(in context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<Tag> = Tag.fetchRequest()
        let count = try! context.count(for: fetchRequest)
        
        if count > 0 {
            debugPrint("already created \(count) tags")
        } else {
            ["#general", "#shopping list", "#study", "#work", "#yolo", "#swag"].forEach { create(title: $0, in: context) }
        }
    }
    
    static func create(title: String, in context: NSManagedObjectContext) {
        let tag = Tag(context: context)
        tag.title = title
        tag.id = UUID()
        tag.uiColor = UIColor.random
    }
}
