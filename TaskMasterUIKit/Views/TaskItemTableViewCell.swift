//
//  TaskItemTableViewCell.swift
//  TaskMasterUIKit
//
//  Created by mac 2019 on 11/12/23.
//

import UIKit

class TaskItemTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageAlarm: UIImageView!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var buttonToggleCompletion: UIButton!
    
    //MARK: - Properties
    private var delegate: TaskItemTableViewCellDelegate?
    private var taskItem: TaskItem!
    
    //MARK: - Functions
    @IBAction func buttonToggleCompletionPressed(_ sender: UIButton) {
        delegate?.toggleCompletion(sender: self)
    }
    
    func populate(from taskItem: TaskItem, delegate: TaskItemTableViewCellDelegate?){
        self.taskItem = taskItem
        self.delegate = delegate
        //Populate UI fields
        labelTitle.text = taskItem.title
        labelTime.text = taskItem.addOrLastEditTime
        
        let image = UIImage(systemName: taskItem.completed ? "square" : "checkmark.square.fill")
        buttonToggleCompletion.setImage(image, for: .normal)
        
        imageAlarm.layer.opacity = taskItem.remind ? 1 : 0.1
        updateTimeLabel()
    }
    
    func updateTimeLabel(){
        DispatchQueue.main.asyncAfter(deadline: .init(uptimeNanoseconds: 10)){ [weak self] in
            guard let self else { return }
            
            self.labelTime.text = self.taskItem.addOrLastEditTime
            self.updateTimeLabel()
        }
    }
}

protocol TaskItemTableViewCellDelegate: AnyObject  {
    func toggleCompletion(sender: TaskItemTableViewCell)
}
