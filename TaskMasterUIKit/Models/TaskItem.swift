//
//  TaskItem.swift
//  TaskMasterUIKit
//
//  Created by mac 2019 on 11/12/23.
//

import Foundation

struct TaskItem: Identifiable, Codable {
    private(set) var id: UUID = UUID()
    var title: String
    
    var notes: String = ""
    var deadline: Date? = nil
    var completed: Bool = true
    var creationTime: Date = .now
    
    var remind: Bool {
        deadline != nil
    }
    
    static var dummies: [TaskItem]{
        [
            TaskItem(title: "My Task Item 1", deadline: .now + 15, completed: false, creationTime: .now - 5000),
            TaskItem(title: "My Task Item 2", deadline: .now + 30, creationTime: .now - 2500),
            TaskItem(title: "My Task Item 3", deadline: .now + 80, creationTime: .now - 610),
            TaskItem(title: "My Task Item 4", notes: "Note for task item 4", deadline: .now + 120, creationTime: .now - 245),
            TaskItem(title: "My Task Item 5", deadline: .now + 5000),
            TaskItem(title: "My Task Item 6", creationTime: .now),
            
            TaskItem(title: "My Task Item 7", deadline: .now + 6000, creationTime: .now - 5000),
            TaskItem(title: "My Task Item 8", deadline: .now + 7000, creationTime: .now - 7500),
            TaskItem(title: "My Task Item 9", deadline: .now + 8000, creationTime: .now - 8610),
            TaskItem(title: "My Task Item 10", deadline: .now + 10020, creationTime: .now - 10000),
            TaskItem(title: "My Task Item 11", deadline: .now + 10000),
            TaskItem(title: "My Task Item 12", completed: false, creationTime: .now)
        ]
    }
}
