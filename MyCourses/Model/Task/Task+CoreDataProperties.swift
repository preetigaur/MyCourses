//
//  Task+CoreDataProperties.swift
//  MyCourses
//
//  Created by Preeti Gaur on 29/04/17.
//  Copyright © 2017 example. All rights reserved.
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task");
    }

    @NSManaged public var percentComplete: String?
    @NSManaged public var dateCreated: NSDate?
    @NSManaged public var dueDate: NSDate?
    @NSManaged public var name: String?
    @NSManaged public var notes: String?
    @NSManaged public var startDate: NSDate?
    @NSManaged public var courseWork: CourseWork?

}
