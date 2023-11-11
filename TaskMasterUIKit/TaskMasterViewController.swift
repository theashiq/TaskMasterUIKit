//
//  TaskMasterViewController.swift
//  TaskMasterUIKit
//
//  Created by mac 2019 on 11/11/23.
//

import UIKit

class TaskMasterViewController: UIViewController{

    @IBOutlet weak var taskItemsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        taskItemsTableView.delegate = self
        taskItemsTableView.dataSource = self
    }
    
    private var data: [TaskItem] = TaskItem.dummies
}

extension TaskMasterViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = taskItemsTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if let taskCellView = cell as? TaskItemTableViewCell{
            taskCellView.populate(from: data[indexPath.row])
            taskCellView.delegate = self
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

extension TaskMasterViewController: TaskItemTableViewCellDelegate{

    func toggleCompletion(sender: TaskItemTableViewCell) {
        if let indexPath = taskItemsTableView.indexPath(for: sender){
            data[indexPath.row].completed.toggle()
            taskItemsTableView.reloadRows(at: [indexPath], with: .automatic)
            //MARK: - Save data to db
            //saveData()
        }
    }
    
}

class TaskItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageAlarm: UIImageView!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var buttonToggleCompletion: UIButton!
    
    var delegate: TaskItemTableViewCellDelegate?
    
    @IBAction func buttonToggleCompletionPressed(_ sender: UIButton) {
        delegate?.toggleCompletion(sender: self)
    }
    
    func populate(from taskItem: TaskItem){
        
        //Populate UI fields
        labelTitle.text = taskItem.title
        labelTime.text = taskItem.addOrLastEditTime
        
        let image = UIImage(systemName: taskItem.completed ? "square" : "checkmark.square.fill")
        buttonToggleCompletion.setImage(image, for: .normal)
        
        imageAlarm.layer.opacity = taskItem.remind ? 1 : 0.1
    }
}

protocol TaskItemTableViewCellDelegate: AnyObject  {
    func toggleCompletion(sender: TaskItemTableViewCell)
}


struct TaskItem: Identifiable, Codable {
    private(set) var id: UUID = UUID()
    var title: String
    var notes: String
    var remind: Bool = true
    var completed: Bool = false
    var creationTime: Date = .now
    var lastEditTime: Date? = nil
    
    static var dummies: [TaskItem]{
        [
            TaskItem(title: "My Task Item", notes: ""),
            TaskItem(title: "My Task Item 2", notes: "", completed: true),
            TaskItem(title: "My Task Item 3", notes: "", remind: false),
            TaskItem(title: "My Task Item 4", notes: "Note for task item 4"),
            TaskItem(title: "My Task Item 5", notes: "", remind: true)
        ]
    }
}

extension TaskItem{
    var addOrLastEditTime: String{
        if let lastEditTime{
            return "Last edited at \(lastEditTime.meaningful)"
        }
        
        return "Added at \(creationTime.meaningful)"
    }
}

extension Date{
    var meaningful: String{
        self.formatted(date: .abbreviated, time: .shortened)
    }
}
