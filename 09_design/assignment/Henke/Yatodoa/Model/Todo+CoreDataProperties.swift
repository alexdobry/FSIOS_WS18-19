//
//  Todo+CoreDataProperties.swift
//  Yatodoa
//
//  Created by Alex Dobrynin on 04.12.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//
//

import Foundation
import CoreData


extension Todo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Todo> {
        return NSFetchRequest<Todo>(entityName: "Todo")
    }

    @NSManaged public var created: Date
    @NSManaged public var task: String
    @NSManaged public var favorite: Bool
    @NSManaged public var id: UUID
    @NSManaged public var tags: NSSet?
    @NSManaged private(set) public var finished: Date?
    @NSManaged private(set) public var completed: Bool
    
    func complete(to bool: Bool) {
        completed = bool
        finished = bool ? Date() : nil
    }
}

// MARK: Generated accessors for tags
extension Todo {

    @objc(addTagsObject:)
    @NSManaged public func addToTags(_ value: Tag)

    @objc(removeTagsObject:)
    @NSManaged public func removeFromTags(_ value: Tag)

    @objc(addTags:)
    @NSManaged public func addToTags(_ values: NSSet)

    @objc(removeTags:)
    @NSManaged public func removeFromTags(_ values: NSSet)

}
