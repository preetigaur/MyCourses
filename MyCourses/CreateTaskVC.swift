//
//  CreateTaskVC.swift
//  MyCourses
//
//  Created by Preeti Gaur on 23/04/17.
//  Copyright © 2017 example. All rights reserved.
//

import UIKit
import CoreData

class CreateTaskVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var nameTextfield: UITextField!
    @IBOutlet var startDateTextfield: UITextField!
    @IBOutlet var dueDateTextfield: UITextField!
    @IBOutlet var percentCompleteLabel: UILabel!
    @IBOutlet var marksSlider: UISlider!
    @IBOutlet var toolBar: UIToolbar!
    @IBOutlet var notesTextview: UITextView!
    
    var courseWork : CourseWork? = nil
    var task : Task? = nil
    var saveButton : UIBarButtonItem = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dueDateTextfield.delegate = self
        startDateTextfield.delegate =  self
        nameTextfield.delegate = self
        
        saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action:#selector(saveButtonIsPressed(_:)))
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonIsPressed(_:)))
        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        //add cancel and save button to toolbar
        self.toolBar.setItems([cancelButton,flexButton, saveButton], animated: true)
        self.toolBar.sizeToFit()
        
        if self.task != nil {
             //populate fields in save mode
            self.setPopulateFields()
        } else {
            // new task is to be created, hence disable save button initially
            saveButton.isEnabled = false
        }
    }
    
    func setPopulateFields() {
        self.nameTextfield.text = self.task?.name?.description
        self.startDateTextfield.text = Utilities.dateToString((self.task?.startDate as! Date))
        self.dueDateTextfield.text = Utilities.dateToString((self.task?.dueDate as! Date))
        self.notesTextview.text =  self.task?.notes?.description
        self.percentCompleteLabel.text = (self.task?.percentComplete?.description)! + "% Complete"
        self.marksSlider.value = Float((self.task?.percentComplete?.description)!)!
        //self.marksSlider.value = Float((self.task?.marks)!)!
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        self.percentCompleteLabel.text = "\(currentValue)% Complete"
    }
    
    func cancelButtonIsPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func saveButtonIsPressed(_ sender: UIBarButtonItem) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).coreDataStack.persistentContainer.viewContext
        
        let task : Task
        
        if self.task != nil {
            //task is being edited
            task = self.task!
        } else {
            //new task is being created
            task = Task(context: context)
        }
        
        task.name = self.nameTextfield.text?.trimmingCharacters(in: .whitespaces)
        
        let startDate : Date = Utilities.stringToDate(self.startDateTextfield.text!)
        task.startDate = startDate as NSDate?
        
        let dueDate : Date = Utilities.stringToDate(self.dueDateTextfield.text!)
        task.dueDate = dueDate as NSDate?
        
        task.percentComplete = "\(Int(self.marksSlider.value))"
        task.notes = self.notesTextview.text
        task.dateCreated = Utilities.getCurrentDate() as NSDate?
        task.courseWork = self.courseWork
        
        self.courseWork?.addToTasks(task)
        self.courseWork = Utilities.calculateCourseWorkPercentCompleted(self.courseWork!)
        self.saveContext(context)
    }
    
    func saveContext(_ context : NSManagedObjectContext) {
        // Save the context.
        do {
            try context.save()
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "CourseWorkEdited")))
            self.dismiss(animated: true, completion: nil)
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    //MARK:- UIDatePicker Delegate Methods
    
    func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        if sender.tag == 0 {
            startDateTextfield.text = ""
            startDateTextfield.insertText(dateFormatter.string(from: sender.date))
            
        } else {
            dueDateTextfield.text = ""
            dueDateTextfield.insertText(dateFormatter.string(from: sender.date))
        }
    }
    
     //MARK:- UiTextField Delegate Methods
    
    @IBAction func textFieldEditing(_ sender: UITextField) {
        if sender == self.startDateTextfield || sender == self.dueDateTextfield {
            let datePickerView:UIDatePicker = UIDatePicker()
            datePickerView.datePickerMode = UIDatePickerMode.date
            datePickerView.tag = sender.tag
            sender.inputView = datePickerView
            datePickerView.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: UIControlEvents.valueChanged)
        }
    }
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        //disable save button if name, start date, end date are not entered
        if (nameTextfield.text?.trimmingCharacters(in: .whitespaces).isEmpty)! ||
            (startDateTextfield.text?.trimmingCharacters(in: .whitespaces).isEmpty)! ||
            (dueDateTextfield.text?.trimmingCharacters(in: .whitespaces).isEmpty)!  {
            //Disable button
            saveButton.isEnabled = false
        
        } else {
            //Enable button
            saveButton.isEnabled = true
        }
    }
}
