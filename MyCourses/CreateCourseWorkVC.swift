//
//  CreateCourseWorkVC.swift
//  MyCourses
//
//  Created by Preeti Gaur on 22/04/17.
//  Copyright © 2017 example. All rights reserved.
//

import UIKit
import EventKit

class CreateCourseWorkVC: UIViewController, UITextFieldDelegate {

    @IBOutlet var nameTextfield: UITextField!
    @IBOutlet var moduleTextfield: UITextField!
    @IBOutlet var levelTextfield: UITextField!
    @IBOutlet var weightTextfield: UITextField!
    @IBOutlet var dueDateTextfield: UITextField!
    @IBOutlet var marksLabel: UILabel!
    @IBOutlet var marksSlider: UISlider!
    @IBOutlet var toolBar: UIToolbar!
    @IBOutlet var notesTextview: UITextView!
    var courseWorkItem: CourseWork? = nil
    var saveButton : UIBarButtonItem = UIBarButtonItem()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dueDateTextfield.delegate = self
        
         saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action:#selector(saveButtonIsPressed(_:)))
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonIsPressed(_:)))
        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        //add cancel and save button to toolbar
        self.toolBar.setItems([cancelButton,flexButton, saveButton], animated: true)
        self.toolBar.sizeToFit()
        
        if self.courseWorkItem != nil {
            //populate fields in save mode
            self.setPopulateFields()
        } else {
            // new course work is to be created, hence disable save button initially
            saveButton.isEnabled = false
        }
        // Do any additional setup after loading the view.
    }

    func setPopulateFields() {
        self.nameTextfield.text = self.courseWorkItem?.name?.description
        self.moduleTextfield.text = self.courseWorkItem?.moduleName?.description
        self.dueDateTextfield.text = Utilities.dateToString((self.courseWorkItem?.dueDate as! Date))
        self.notesTextview.text =  self.courseWorkItem?.notes?.description
        self.levelTextfield.text = self.courseWorkItem?.level?.description
        self.weightTextfield.text = self.courseWorkItem?.weight?.description
        self.marksSlider.value = Float((self.courseWorkItem?.marks)!)!
        self.marksLabel.text = (self.courseWorkItem?.marks?.description)! + "/100"
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        self.marksLabel.text = "\(currentValue)/100"
    }
    
    func cancelButtonIsPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func saveButtonIsPressed(_ sender: UIBarButtonItem) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).coreDataStack.persistentContainer.viewContext
        
        let courseWork : CourseWork
    
        if self.courseWorkItem != nil {
            //course work is being edited
            courseWork = self.courseWorkItem!
        } else {
            //new course work is being created
            courseWork = CourseWork(context: context)
        }
        
        courseWork.name = self.nameTextfield.text?.trimmingCharacters(in: .whitespaces)
        courseWork.moduleName = self.moduleTextfield.text?.trimmingCharacters(in: .whitespaces)
        
        let dueDate : Date = Utilities.stringToDate(self.dueDateTextfield.text!)
        courseWork.dueDate = dueDate as NSDate?
    
        courseWork.dateCreated = Utilities.getCurrentDate() as NSDate?
        courseWork.level = self.levelTextfield.text?.trimmingCharacters(in: .whitespaces)
        courseWork.weight = self.weightTextfield.text?.trimmingCharacters(in: .whitespaces)
        courseWork.marks = "\(Int(self.marksSlider.value))"
        courseWork.notes = self.notesTextview.text
        courseWork.percentComplete = "0"
        
        // Save the context.
        do {
            try context.save()
            self.dismiss(animated: true, completion: nil)
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        if self.courseWorkItem != nil {
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "CourseWorkEdited")))
        } else {
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "CourseWorkCreated")))
        }
    }
    
    
    //MARK:- UIDatePicker Delegate Methods
    
    func datePickerValueChanged(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dueDateTextfield.text = ""
        dueDateTextfield.insertText(dateFormatter.string(from: sender.date))
    }
    
    //MARK:- UiTextField Delegate Methods
    
    @IBAction func textFieldEditing(_ sender: UITextField) {
        
        if sender == self.dueDateTextfield {
            let datePickerView:UIDatePicker = UIDatePicker()
            datePickerView.datePickerMode = UIDatePickerMode.date
            sender.inputView = datePickerView
            datePickerView.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: UIControlEvents.valueChanged)
        }
    }
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        
        //disable save button if coursework name, module name, duedate, level, weight are not entered
        if (nameTextfield.text?.trimmingCharacters(in: .whitespaces).isEmpty)! ||
            (moduleTextfield.text?.trimmingCharacters(in: .whitespaces).isEmpty)! ||
            (dueDateTextfield.text?.trimmingCharacters(in: .whitespaces).isEmpty)! ||
            (levelTextfield.text?.trimmingCharacters(in: .whitespaces).isEmpty)! ||
            (weightTextfield.text?.trimmingCharacters(in: .whitespaces).isEmpty)!  {
            //Disable button
            saveButton.isEnabled = false
            
        } else {
            //Enable button
            saveButton.isEnabled = true
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
