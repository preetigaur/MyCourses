//
//  CourseWorkCell.swift
//  MyCourses
//
//  Created by Preeti Gaur on 23/04/17.
//  Copyright © 2017 example. All rights reserved.
//

import UIKit

class CourseWorkCell: UITableViewCell {
    
    @IBOutlet var courseNameLabel: UILabel!
    @IBOutlet var moduleNameLabel: UILabel!
    @IBOutlet var dueDateLabel: UILabel!
    @IBOutlet var weightLabel: UILabel!
    @IBOutlet var levelLabel: UILabel!
    @IBOutlet var daysLeftLabel: UILabel!
    @IBOutlet var markSlider: UISlider!
    @IBOutlet var progressView: UIProgressView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
