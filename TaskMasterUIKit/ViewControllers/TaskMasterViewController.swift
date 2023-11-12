//
//  TaskMasterViewController.swift
//  TaskMasterUIKit
//
//  Created by mac 2019 on 11/11/23.
//

import UIKit

class TaskMasterViewController: UIViewController{

    //MARK: - IBOutlets
    @IBOutlet weak var taskItemsTableView: UITableView!
    @IBOutlet weak var barButtonEdit: UIBarButtonItem!
    @IBOutlet weak var barButtonAdd: UIBarButtonItem!
    
    //MARK: - Properties
    private var data: [TaskItem] = TaskItem.dummies
    
    //MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        taskItemsTableView.delegate = self
        taskItemsTableView.dataSource = self
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @IBAction func onBarButtonEditPressed(_ sender: UIBarButtonItem) {
        taskItemsTableView.setEditing(!taskItemsTableView.isEditing, animated: true)
        barButtonAdd.isEnabled = !taskItemsTableView.isEditing
        barButtonEdit.title = taskItemsTableView.isEditing ? "Done" : "Edit"
    }
}

//MARK: - UITableView Delegates
extension TaskMasterViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = taskItemsTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if let taskCellView = cell as? TaskItemTableViewCell{
            taskCellView.populate(from: data[indexPath.row], delegate: self)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            tableView.deleteRows(at: [indexPath], with: .fade)
            data.remove(at: indexPath.row)
            // TODO: Delete from DB
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let temp = data[sourceIndexPath.row]
        data[sourceIndexPath.row] = data[destinationIndexPath.row]
        data[destinationIndexPath.row] = temp
        // TODO: Update DB
    }
}

// MARK: - TaskItemTableViewCellDelegate
extension TaskMasterViewController: TaskItemTableViewCellDelegate{

    func toggleCompletion(sender: TaskItemTableViewCell) {
        if let indexPath = taskItemsTableView.indexPath(for: sender){
            data[indexPath.row].completed.toggle()
            taskItemsTableView.reloadRows(at: [indexPath], with: .automatic)
            //TODO: Update DB
        }
    }
    
}


