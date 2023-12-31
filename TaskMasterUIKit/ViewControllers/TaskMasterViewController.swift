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
//    private var data: [TaskItem] = TaskItem.dummies
    private var dataProvider: DataProvider = .shared
    
    //MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.prefersLargeTitles = true
        NotificationManager.requestAuthorization(callback: nil)
        dataProvider.delegate = self
        dataProvider.loadData()
    }
    
    @IBAction func onBarButtonEditPressed(_ sender: UIBarButtonItem) {
        taskItemsTableView.setEditing(!taskItemsTableView.isEditing, animated: true)
        barButtonAdd.isEnabled = !taskItemsTableView.isEditing
        barButtonEdit.title = taskItemsTableView.isEditing ? "Done" : "Edit"
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Modal_AddTask",
           let navController = (segue.destination as? UINavigationController),
           let toDoItemViewController = navController.topViewController as? TaskItemTableViewController{
            
            toDoItemViewController.onTaskItemChanged = onTaskItemChanged
        }
        
        else if let toDoItemViewController = segue.destination as? TaskItemTableViewController{
            
            toDoItemViewController.onTaskItemChanged = onTaskItemChanged
            
            if segue.identifier == "Segue_ViewEditTask",
               let selectedRow = taskItemsTableView.indexPathForSelectedRow?.row
            {
                toDoItemViewController.taskItem = dataProvider.data[selectedRow]
            }
        }
    }
    
    private func onTaskItemChanged(taskItem: TaskItem){
        
        if dataProvider.indexOf(task: taskItem) != nil{
            dataProvider.updateTask(updatedTask: taskItem)
        }
        else{
            dataProvider.addNewTask(newTask: taskItem)
        }
    }
    
    private func setNotificationForTask(at index: Int){
        if let task = self.dataProvider.taskAt(index: index){
            NotificationManager.cancelNotification(id: task.id.uuidString)
            
            if task.remind, let time = task.remindTime{
                NotificationManager.setNotification(id: task.id.uuidString, title: task.title, body: task.notes, time: time)
            }
        }
    }
}

//MARK: - UITableView Delegates
extension TaskMasterViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("datadatadata count \(dataProvider.data.count)")
        return dataProvider.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = taskItemsTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if let taskCellView = cell as? TaskItemTableViewCell{
            taskCellView.populate(from: dataProvider.data[indexPath.row], delegate: self)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            dataProvider.deleteTask(index: indexPath.row)
            if let deletedTask = dataProvider.taskAt(index: indexPath.row){
                NotificationManager.cancelNotification(id: deletedTask.id.uuidString)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        dataProvider.swapTasks(index1: sourceIndexPath.row, index2: destinationIndexPath.row)
    }
}

// MARK: - TaskItemTableViewCellDelegate
extension TaskMasterViewController: TaskItemTableViewCellDelegate{

    func toggleCompletion(sender: TaskItemTableViewCell) {
        if let indexPath = taskItemsTableView.indexPath(for: sender){
            var task = dataProvider.taskAt(index: indexPath.row)
            if task != nil{
                task?.completed.toggle()
                dataProvider.updateTask(updatedTask: task!)
            }
        }
    }
    
}

// MARK: - DataProviderDelegate
extension TaskMasterViewController: DataProviderDelegate{

    func onDataLoaded() {
        DispatchQueue.main.async {
            self.taskItemsTableView.delegate = self
            self.taskItemsTableView.dataSource = self
            self.taskItemsTableView.reloadData()
        }
    }
    
    func onNewTaskAdded(newTaskIndex: Int) {
        DispatchQueue.main.async{
            self.taskItemsTableView.insertRows(at: [IndexPath(item: newTaskIndex, section: 0)], with: .automatic)
            self.setNotificationForTask(at: newTaskIndex)
        }
    }
    
    func onTaskUpdated(updatedTaskIndex: Int) {
        
        DispatchQueue.main.async{
            let iPath = IndexPath(item: updatedTaskIndex, section: 0)
            self.taskItemsTableView.reloadRows(at: [iPath], with: .automatic)
            self.setNotificationForTask(at: updatedTaskIndex)
        }
    }
    
    func onTaskDeleted(deletedFromIndex: Int) {
        DispatchQueue.main.async{
            let indexPath = IndexPath(row: deletedFromIndex, section: 0)
            self.taskItemsTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func onTaskIndicesSwapped(index1: Int, index2: Int) {
        //nothing to do
    }
    
    func onDataError(error: Error) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Error Occurred", message: error.localizedDescription, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
}
