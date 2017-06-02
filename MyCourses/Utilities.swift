//
//  Utilities.swift
//  MyCourses
//
//  Created by Preeti Gaur on 22/04/17.
//  Copyright © 2017 example. All rights reserved.
//

import UIKit
import CoreData

class Utilities: NSObject {
    
    class func dateToString(_ date : Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy" //Your New Date format as per requirement change it own
        dateFormatter.timeZone = TimeZone(identifier: "UTC")//TimeZone(secondsFromGMT: 0)
        let newDate = dateFormatter.string(from: date)
        return newDate
    }
    
    class func stringToDate(_ string : String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy" //Your date format
         dateFormatter.timeZone = TimeZone(identifier: "UTC")//TimeZone(secondsFromGMT: 0)
        let date = dateFormatter.date(from: string) //according to date format your date string
        return date!
    }
    
    class func getCurrentDate() -> Date {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        formatter.timeZone = TimeZone(identifier: "UTC")//TimeZone(secondsFromGMT: 0)
        let result = formatter.string(from: date)
        return self.stringToDate(result)
    }
    
    class func stringFromTimeInterval(interval: TimeInterval) -> String {
        var interval = Int(interval)
       var days = interval / (60 * 60 * 24)
       interval -= days * (60 * 60 * 24)
       var  hours = interval / (60 * 60)
       // interval -= hours * (60 * 60)
//       let minutes = interval / 60
        
        if days < 0 {
            days = 0
        }
        
        if hours < 0 {
            hours = 0
        }
        
        return String(format: "%dd %dh left", days, hours)
    }
    
    class func fullStringFromTimeInterval(interval: TimeInterval) -> String {
        var interval = Int(interval)
        var days = interval / (60 * 60 * 24)
        interval -= days * (60 * 60 * 24)
        var  hours = interval / (60 * 60)
        // interval -= hours * (60 * 60)
        //       let minutes = interval / 60
        
        if days < 0 {
            days = 0
        }
        
        if hours < 0 {
            hours = 0
        }
        
        return String(format: "%ddays %dhours left", days, hours)
    }
    
    class func calculateCourseWorkPercentCompleted(_ courseWork : CourseWork) -> CourseWork {
        let tasks : NSSet =  (courseWork.tasks)!
        if tasks.count > 0 {
            var totalPercentCompleted : Int = 0
            for task in tasks {
                totalPercentCompleted += Int((task as! Task).percentComplete!)!
            }
            let aggregatePercent : Int = totalPercentCompleted / Int((courseWork.tasks?.count)!)
            courseWork.percentComplete = "\(aggregatePercent)"
        } else {
            courseWork.percentComplete = "\(0)"
        }
        return courseWork
    }
    
}
