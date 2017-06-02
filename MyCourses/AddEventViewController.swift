//
//  AddEventViewController.swift
//  MyCourses
//
//  Created by Preeti Gaur on 30/4/17.
//  Copyright © 2017 example. All rights reserved.
//

import UIKit
import EventKit

class AddEventViewController: UIViewController {

    var calendar: EKCalendar!

    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var eventStartDatePicker: UIDatePicker!
    @IBOutlet weak var eventEndDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.eventStartDatePicker.setDate(initialDatePickerValue(), animated: false)
        self.eventEndDatePicker.setDate(initialDatePickerValue(), animated: false)
    }
    
    func initialDatePickerValue() -> Date {
        let calendarUnitFlags: NSCalendar.Unit = [.year, .month, .day, .hour, .minute, .second]
        
        var dateComponents = (Calendar.current as NSCalendar).components(calendarUnitFlags, from: Date())
        
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        
        return Calendar.current.date(from: dateComponents)!
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func checkForEventAuthorization(eventStore: EKEventStore, completionHandler block:@escaping (_ granted: Bool, _ error: NSError?) -> Void)  {
        if eventStore.responds(to: #selector(EKEventStore.requestAccess(to:completion:))) == true {
            eventStore.requestAccess(to: EKEntityType.event, completion: { (granted, error) -> Void in
                block(granted, error as NSError?)
            })
        } else {
            block (true, nil)
        }
    }
    
    @IBAction func addEventButtonTapped(_ sender: UIBarButtonItem) {
        let store = EKEventStore()
        store.requestAccess(to: .event) {(granted, error) in
            if !granted { return }
            let newEvent = EKEvent(eventStore: store)
            newEvent.title = self.eventNameTextField.text ?? "Some Event Name"
            newEvent.startDate = self.eventStartDatePicker.date
            newEvent.endDate = self.eventEndDatePicker.date
            newEvent.calendar = store.defaultCalendarForNewEvents
            
            do {
                try store.save(newEvent, span: .thisEvent, commit: true)
                self.dismiss(animated: true, completion: nil)
                
            } catch {
                // Display error to user
                let alert = UIAlertController(title: "Event could not be saved.", message: (error as NSError).localizedDescription, preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(OKAction)
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
