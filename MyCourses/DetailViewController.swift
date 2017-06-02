//
//  DetailViewController.swift
//  MyCourses
//
//  Created by Preeti Gaur on 22/04/17.
//  Copyright © 2017 example. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource, TaskCellDelegate {
    
    @IBOutlet var moduleNameLabel: UILabel!
    @IBOutlet var weightLabel: UILabel!
    @IBOutlet var levelLabel: UILabel!
    @IBOutlet var markLevel: UILabel!
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var percentCompleteLabel: UILabel!
    @IBOutlet var daysLeftLabel: UILabel!
    @IBOutlet var notesTextView: UITextView!
    @IBOutlet var toolBar: UIToolbar!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var imageView: UIImageView!
    
    var isKeyBoardVisible : Bool = false
    
    var managedObjectContext: NSManagedObjectContext? = nil
    var _fetchedResultsController: NSFetchedResultsController<Task>? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let context = (UIApplication.shared.delegate as! AppDelegate).coreDataStack.persistentContainer.viewContext
        self.managedObjectContext = context
        
        self.loadFirstCourseWork()
    
        NotificationCenter.default.addObserver(self, selector: #selector(configureView), name: NSNotification.Name(rawValue: "CourseWorkEdited"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadFirstCourseWork), name: NSNotification.Name(rawValue: "CourseWorkCreated"), object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(courseWorkIsDeleted), name: NSNotification.Name(rawValue: "CourseWorkDeleted"), object: nil)
    }
    
    func addCalenderEventForTask() {
        self.performSegue(withIdentifier: "addEventSegue", sender: self)
    }

    func alarmButtonIsPressed(_ sender: UIBarButtonItem) {
         DispatchQueue.main.async() {
            self.performSegue(withIdentifier: "alarmSegue", sender: self)
        }
    }
    
    func loadFirstCourseWork() {
        
        if self.courseWorkItem ==  nil {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName:"CourseWork")
            request.fetchLimit = 1
            do {
                let results = try self.managedObjectContext?.fetch(request) as! [CourseWork]
                if results.count == 1 {
                    self.courseWorkItem = results[0]
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        if self.courseWorkItem != nil {
            self.configureView()
        }
    }
    
    func courseWorkIsDeleted() {
        if (self.courseWorkItem != nil) {
            
            do {
                let request = NSFetchRequest<NSFetchRequestResult>(entityName:"CourseWork")
                request.predicate =  NSPredicate(format: "name == %@", (self.courseWorkItem?.name)!)
                
                let results = try self.managedObjectContext?.fetch(request) as! [CourseWork]
                if results.count == 0 {
                    self.clearView()
                    //self.courseWorkItem = nil
                }
            } catch let error {
                print(error.localizedDescription)
            }

        }
    }
    

    func configureView() {
        
        if self.courseWorkItem != nil {
            
            //configure navigation items
            let edit = UIBarButtonItem(image: UIImage(named:"Edit"),
                                       style: .plain,
                                       target: self,
                                       action: #selector(editCourseWorkButtonIsPressed(_:)))
            let alarm = UIBarButtonItem(image: UIImage(named:"Alarm"),
                                        style: .plain,
                                        target: self,
                                        action: #selector(alarmButtonIsPressed(_:)))
            
            self.navigationItem.setRightBarButtonItems([alarm,edit], animated: false)
            
            
            //configure tool bar
            let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            let addEventButton = UIBarButtonItem(image: UIImage(named:"Calendar"),
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(addCalenderEventForTask))
            
            let addNewTaskButton = UIBarButtonItem(image: UIImage(named:"Plus"),
                                                   style: .plain,
                                                   target: self,
                                                   action: #selector(showNewTaskPopOver(_:)))
            
            self.toolBar.setItems([flexButton, addEventButton, addNewTaskButton], animated: true)
            self.toolBar.sizeToFit()
        }

        self.title = self.courseWorkItem?.name?.description
        self.tableView.dataSource = self
        self.tableView.delegate = self
        _fetchedResultsController = nil
        self.tableView.reloadData()
        
        // Update the user interface for the detail item.
        if let courseWork = self.courseWorkItem {
            self.moduleNameLabel.text = "Module: " + courseWork.moduleName!
            self.weightLabel.text = "Weight: \(courseWork.weight!.description)%"
            self.levelLabel.text = "Level: \(courseWork.level!.description)"
            self.notesTextView.text = "Notes: " + (courseWork.notes?.description)!
            self.markLevel.text = "Mark: " + courseWork.marks! + "/100"
            self.daysLeftLabel.text = Utilities.fullStringFromTimeInterval(interval: (courseWork.dueDate?.timeIntervalSinceNow)!)
            self.percentCompleteLabel.text = (courseWork.percentComplete?.description)! + "% Complete"
            self.progressView.progress = Float(courseWork.percentComplete!)! / 100
            if self.daysLeftLabel.text == "0days 0hours left" {
                self.imageView.image = UIImage(named: "RedCircle")
            } else {
                self.imageView.image = UIImage(named: "GreenCircle")
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func clearView() {
        self.moduleNameLabel.text = "Module Name"
        self.weightLabel.text = ""
        self.levelLabel.text = ""
        self.notesTextView.text = ""
        self.markLevel.text = ""
        self.daysLeftLabel.text = ""
        self.percentCompleteLabel.text = ""
        self.progressView.progress = 0.0
        self.imageView.image = UIImage(named: "GreenCircle")
        self.navigationItem.rightBarButtonItems?.removeAll()
        self.toolBar.items?.removeAll()
    
    }
    
    func editCourseWorkButtonIsPressed(_ sender: UIBarButtonItem) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let  createCoursePopOver = storyBoard.instantiateViewController(withIdentifier: "CreateCourseWorkVC") as! CreateCourseWorkVC
        createCoursePopOver.preferredContentSize = CGSize(width: 300, height: 314)
        createCoursePopOver.courseWorkItem = self.courseWorkItem
        createCoursePopOver.modalPresentationStyle = .popover
        if let presentation = createCoursePopOver.popoverPresentationController {
            presentation.barButtonItem = sender
            presentation.sourceView = self.view
            presentation.sourceRect = CGRect(x:self.view.bounds.midX, y: self.view.bounds.midY,width: 300,height: 314)
            
        }
        present(createCoursePopOver, animated: true, completion: nil)
    }

    func keyboardWillShow() {
        if !self.isKeyBoardVisible {
            self.isKeyBoardVisible =  true
            
            //print(UIDevice.current.orientation.isLandscape)
            if UIDevice.current.orientation.isLandscape {
                self.view.frame.origin.y -= 250
            }
        }
    }
    
    func keyboardWillHide() {
        if self.isKeyBoardVisible {
            self.isKeyBoardVisible = false
            if UIDevice.current.orientation == .landscapeLeft ||
                UIDevice.current.orientation == .landscapeRight {
                self.view.frame.origin.y += 250
            }
        }
    }
    
    func showNewTaskPopOver(_ sender: UIBarButtonItem) {
    
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let  createTaskPopover = storyBoard.instantiateViewController(withIdentifier: "CreateTaskVC") as! CreateTaskVC
        createTaskPopover.preferredContentSize = CGSize(width: 400, height: 310)
        createTaskPopover.courseWork = self.courseWorkItem
        
        createTaskPopover.modalPresentationStyle = .popover
        if let presentation = createTaskPopover.popoverPresentationController {
            presentation.barButtonItem = sender
            presentation.sourceView = self.view
            presentation.sourceRect = CGRect(x:self.view.bounds.midX, y: self.view.bounds.midY,width: 300,height: 310)
            
        }
        present(createTaskPopover, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var courseWorkItem: CourseWork? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    //MARK: - NSFetchedResultsController Delegate Methods
    var fetchedResultsController: NSFetchedResultsController<Task> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.predicate = NSPredicate(format:"courseWork = %@", self.courseWorkItem!)
        
        
        // Set the batch size to a suitable number.
        //fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "dateCreated", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
            
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            self.tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            self.tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            self.configureCell(tableView.cellForRow(at: indexPath!)! as! TaskTableViewCell, withTask: anObject as! Task)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    //MARK: - UITableView Delegate Methods
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as! TaskTableViewCell
        cell.delegate = self
        let task : Task = self.fetchedResultsController.object(at: indexPath)
        cell.editButton.tag = indexPath.row
        self.configureCell(cell, withTask : task)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = self.fetchedResultsController.managedObjectContext
            context.delete(self.fetchedResultsController.object(at: indexPath))
            
            do {
               
                try context.save()
                courseWorkItem =   Utilities.calculateCourseWorkPercentCompleted(courseWorkItem!)
                try context.save()
                
                self.configureView()
                
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func configureCell(_ cell: TaskTableViewCell, withTask task: Task) {
        cell.taskNameLabel.text = task.name?.description
        cell.timeLeftLabel.text = Utilities.stringFromTimeInterval(interval: (task.dueDate?.timeIntervalSinceNow)!)
        cell.notesTextView.text = "Notes : " + (task.notes?.description)!
        cell.percentCompleteLabel.text = task.percentComplete! + "% Complete"

        cell.progressView.progress = Float(task.percentComplete!)! / 100
    }
    
    //MARK:- TaskCellDelegate Method
    
    func editTaskButtonIsPressed(_ sender: Any) {
        print("editButtonIsPressed");
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let  createTaskPopover = storyBoard.instantiateViewController(withIdentifier: "CreateTaskVC") as! CreateTaskVC
        createTaskPopover.preferredContentSize = CGSize(width: 400, height: 310)
        createTaskPopover.modalPresentationStyle = .popover
        
        let task = self.fetchedResultsController.object(at: IndexPath(row: (sender as! UIButton).tag, section: 0))
        createTaskPopover.task = task
        createTaskPopover.courseWork = self.courseWorkItem
            
        if let presentation = createTaskPopover.popoverPresentationController {
            presentation.sourceView = sender as! UIButton
            presentation.sourceRect = CGRect(x:(presentation.sourceView?.bounds.midX)!, y: (presentation.sourceView?.bounds.midY)!,width: 300,height: 310)
        }
        present(createTaskPopover, animated: true, completion: nil)
    }
}

extension DetailViewController: CourseWorkSelectionDelegate {
    func courseWorkSelected(_ newCourseWork: CourseWork) {
        courseWorkItem =  newCourseWork
    }
}


