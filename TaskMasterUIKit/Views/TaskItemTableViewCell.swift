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
    @IBOutlet weak var labelDeadline: UILabel!
    @IBOutlet weak var buttonToggleCompletion: UIButton!
    
    //MARK: - Properties
    private var delegate: TaskItemTableViewCellDelegate?
    private var taskItem: TaskItem!
    private var workTimeLabelUpdate: DispatchWorkItem!
    
    //MARK: - Functions
    @IBAction func buttonToggleCompletionPressed(_ sender: UIButton) {
        delegate?.toggleCompletion(sender: self)
    }
    
    func populate(from taskItem: TaskItem, delegate: TaskItemTableViewCellDelegate?){
        self.taskItem = taskItem
        self.delegate = delegate
        
        updateUI()
    }
    
    private func updateUI(){
        labelTitle.text = taskItem.title
        labelDeadline.text = taskDeadline
        
        let image = UIImage(systemName: taskItem.completed ? "checkmark.square.fill" : "square")
        buttonToggleCompletion.setImage(image, for: .normal)
        
        imageAlarm.layer.opacity = taskItem.remind ? 1 : 0.1
        
        updateDeadlineLabel()
    }
    
    override func prepareForReuse() {
        workTimeLabelUpdate?.cancel()
        print("---> prepareForReuse \(self.taskItem.title)")
    }
    
    
}

//MARK: - Cell extension for time information
extension TaskItemTableViewCell{
    
    private var timeLabelUpdateInterval: DispatchTime? {
        // FIXME: calculate update interval
        
        guard let date = taskItem.remindTime else { return nil }
        
        let secondsAgo = Int(Date().timeIntervalSince(date))

        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour

        if secondsAgo < minute {
            return .now() + 1
        } else if secondsAgo < hour {
            return .now() + 60
        } else if secondsAgo < day {
            return .now() + 3600
        } else {
            return nil
        }
    }
    
    private var deadlineColor: UIColor {
        // FIXME: calculate update interval
        if let deadline = taskItem.remindTime{
            if (deadline < .now + 5) && !taskItem.completed{
                return .red
            }
        }
        return taskItem.completed ? .gray : .black
    }
    
    private var taskDeadline: String {
        
        guard let deadline = taskItem.remindTime else { return "" }
        
        if taskItem.completed{
            return "Deadline \(deadline.formatted(date: .abbreviated, time: .shortened))"
        }
        
        let minuteAgo = Calendar.current.date(byAdding: .minute, value: -1, to: .now)!
        if minuteAgo < deadline {
            return minuteAgo < deadline ? "in seconds" : "seconds ago"
        }
        
        return deadline.asRelativeToNow
    }
    
    private func updateDeadlineLabel(){
        self.labelDeadline.text = self.taskDeadline
        self.labelDeadline.textColor = self.deadlineColor
        
        guard !taskItem.completed else { return }
        guard let updateInterval = timeLabelUpdateInterval else { return }
        
        workTimeLabelUpdate = DispatchWorkItem{ [weak self] in
            guard let self else { return }
            print("updateDeadlineLabel \(self.taskItem.title)")
            self.updateDeadlineLabel()
        }
            
        DispatchQueue.main.asyncAfter(deadline: updateInterval, execute: workTimeLabelUpdate)
    }
    
}

//MARK: - TaskItemTableViewCellDelegate
protocol TaskItemTableViewCellDelegate: AnyObject  {
    func toggleCompletion(sender: TaskItemTableViewCell)
}
/*
extension Date {
    
    func timeAgo() -> Calendar.Component {
        let calendar = Calendar.current
        let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: self)!
        let hourAgo = calendar.date(byAdding: .hour, value: -1, to: self)!
        let dayAgo = calendar.date(byAdding: .day, value: -1, to: self)!
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: self)!

        if minuteAgo < self {
            return .second
        } else if hourAgo < self {
            return .minute
        } else if dayAgo < self {
            return .hour
        } else if weekAgo < self {
            return .day
        }
        return .weekday
    }
    
    func timeAgo2()-> String {

        let secondsAgo = Int(Date().timeIntervalSince(self))

        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        let year = 52 * week

        let quotient: Int
        let unit: String
        if secondsAgo < minute {
            quotient = secondsAgo
            unit = "second"
        } else if secondsAgo < hour {
            quotient = secondsAgo / minute
            unit = "min"
        } else if secondsAgo < day {
            quotient = secondsAgo / hour
            unit = "hour"
        } else if secondsAgo < week {
            quotient = secondsAgo / day
            unit = "day"
        } else if secondsAgo < month {
            quotient = secondsAgo / week
            unit = "week"
        }  else if secondsAgo < year {
            quotient = secondsAgo / month
            unit = "month"
        }else {
            quotient = secondsAgo / year
            unit = "year"
        }
        return "\(quotient) \(unit)\(quotient == 1 ? "" : "s") ago"
    }
}
*/
