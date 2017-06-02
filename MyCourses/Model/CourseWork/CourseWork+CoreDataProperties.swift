//
//  CourseWork+CoreDataProperties.swift
//  MyCourses
//
//  Created by Preeti Gaur on 29/04/17.
//  Copyright © 2017 example. All rights reserved.
//

import Foundation
import CoreData


extension CourseWork {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CourseWork> {
        return NSFetchRequest<CourseWork>(entityName: "CourseWork");
    }

    @NSManaged public var dateCreated: NSDate?
    @NSManaged public var dueDate: NSDate?
    @NSManaged public var level: String?
    @NSManaged public var marks: String?
    @NSManaged public var moduleName: String?
    @NSManaged public var name: String?
    @NSManaged public var notes: String?
    @NSManaged public var weight: String?
    @NSManaged public var percentComplete: String?
    @NSManaged public var tasks: NSSet?

}

// MARK: Generated accessors for tasks
extension CourseWork {

    @objc(addTasksObject:)
    @NSManaged public func addToTasks(_ value: Task)

    @objc(removeTasksObject:)
    @NSManaged public func removeFromTasks(_ value: Task)

    @objc(addTasks:)
    @NSManaged public func addToTasks(_ values: NSSet)

    @objc(removeTasks:)
    @NSManaged public func removeFromTasks(_ values: NSSet)

}
