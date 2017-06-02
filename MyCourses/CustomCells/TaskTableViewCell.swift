//
//  TaskTableViewCell.swift
//  MyCourses
//
//  Created by Preeti Gaur on 24/04/17.
//  Copyright © 2017 example. All rights reserved.
//

import UIKit


protocol TaskCellDelegate: class {
    func editTaskButtonIsPressed(_ sender: Any)
}

class TaskTableViewCell: UITableViewCell {
    
    weak var delegate: TaskCellDelegate?
    
    @IBOutlet var taskNameLabel: UILabel!
    @IBOutlet var timeLeftLabel: UILabel!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var percentCompleteLabel: UILabel!
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var notesTextView: UITextView!
    
    @IBAction func editTaskButtonIsPressed(_ sender: Any) {
        self.delegate?.editTaskButtonIsPressed(sender)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
