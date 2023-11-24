//
//  DataProvider.swift
//  TaskMasterUIKit
//
//  Created by mac 2019 on 11/25/23.
//

import Foundation

struct DataProvider{
    
    private var directoryUrl : URL = {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }()
    
    private var fileUrl : URL{
        directoryUrl.appendingPathComponent("to-do-save").appendingPathExtension(".db")
    }
    
    var data: [TaskItem]{
        taskItems
    }
    private var taskItems: [TaskItem] = []
    var delegate: DataProviderDelegate?
    
    static let shared = DataProvider()
    
    private init(){
        loadData()
    }
    
    private var dataBeingLoaded = false
    mutating func loadData(){

        do {
            taskItems = try JSONDecoder().decode(Array<TaskItem>.self, from: Data(contentsOf: fileUrl))
        }
        catch{
            print(error)
            
            // FIXME: Don't send error @first session
//            delegate?.onDataError(error: error)
        }
        
        if taskItems.count == 0 {
            taskItems.append(
                TaskItem(
                    title: "This is a dummy task",
                    notes: "Additional details of the dummy task"
                )
            )
        }
        
        delegate?.onDataLoaded()
    }
    
    private mutating func saveData(){
        do{
            try JSONEncoder().encode(taskItems).write(to: fileUrl, options: .noFileProtection)
        }
        catch{
            print(error)
            delegate?.onDataError(error: error)
        }
    }
    
    func indexOf(task: TaskItem) -> Int?{
        data.indices.first(where: { data[$0].id == task.id })
    }
    
    func taskAt(index: Int) -> TaskItem? {
        index >= 0 && index < taskItems.count ? taskItems[index] : nil
    }
    
    mutating func addNewTask(newTask: TaskItem) {
        taskItems.insert(newTask, at: 0)
        saveData()
        delegate?.onNewTaskAdded(newTaskIndex: 0)
    }
    
    mutating func updateTask(updatedTask: TaskItem) {
        if let index = indexOf(task: updatedTask){
            taskItems[index] = updatedTask
            saveData()
            delegate?.onTaskUpdated(updatedTaskIndex: index)
        }
        else{
            // TODO: send update error
        }
    }
    
    mutating func deleteTask(taskToDelete: TaskItem){
        if let existingToDoIndex = indexOf(task: taskToDelete){
            deleteTask(index: existingToDoIndex)
        }
        else{
            delegate?.onTaskDeleted(deletedFromIndex: -1)
        }
    }
    
    mutating func deleteTask(index: Int){
        do{
            print("datadatadata 1onDataLoaded1 c \(data.count)")
            print("datadatadata 1onDataLoaded2 c \(taskItems.count)")
            print("datadatadata 1onDataLoaded index \(index)")
            
            try? taskItems.remove(at: index)
            saveData()
            delegate?.onTaskDeleted(deletedFromIndex: index)
        }
        catch{
            delegate?.onDataError(error: error)
        }
    }
    
    mutating func swapTasks(task1: TaskItem, task2: TaskItem){
        
        if let index1 = indexOf(task: task1),
           let index2 = indexOf(task: task2)
        {
            swapTasks(index1: index1, index2: index2)
        }
        else{
            swapTasks(index1: -1, index2: -1)
        }
    }
    
    mutating func swapTasks(index1: Int, index2: Int){
        guard index1 >= 0 && index1 < data.count && index2 >= 0 && index2 < data.count && index1 != index2
        else {
            // TODO: Send error
//            delegate?.onDataError(error: indexerror)
            return
        }
        
        let temp = taskItems[index1]
        taskItems[index1] = taskItems[index2]
        taskItems[index2] = temp
        
        saveData()
        delegate?.onTaskIndicesSwapped(index1: index1, index2: index2)
    }
}

protocol DataProviderDelegate {
    func onDataLoaded()
    func onNewTaskAdded(newTaskIndex: Int)
    func onTaskUpdated(updatedTaskIndex: Int)
    func onTaskDeleted(deletedFromIndex: Int)
    func onTaskIndicesSwapped(index1: Int, index2: Int)
    func onDataError(error: Error)
}

