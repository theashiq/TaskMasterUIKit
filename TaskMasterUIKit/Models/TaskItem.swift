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
    var completed: Bool = false
    var creationTime: Date = .now
    var remindTime: Date? = nil
    var remind: Bool{
        remindTime != nil && remindTime! > .now && !completed
    }
    static var dummies: [TaskItem]{
        [
            TaskItem(title: "My Task Item 1", completed: false, creationTime: .now - 5000, remindTime: .now + 15),
            TaskItem(title: "My Task Item 2", creationTime: .now - 2500, remindTime: .now + 30),
            TaskItem(title: "My Task Item 3", creationTime: .now - 610, remindTime: .now + 80),
            TaskItem(title: "My Task Item 4", notes: "Note for task item 4", creationTime: .now - 245, remindTime: .now + 120),
            TaskItem(title: "My Task Item 5",completed: true, remindTime: .now + 5000),
//            TaskItem(title: "My Task Item 6", creationTime: .now),
//            
//            TaskItem(title: "My Task Item 7", creationTime: .now - 5000, remindTime: .now + 6000),
//            TaskItem(title: "My Task Item 8", creationTime: .now - 7500, remindTime: .now + 7000),
//            TaskItem(title: "My Task Item 9", creationTime: .now - 8610, remindTime: .now + 8000),
//            TaskItem(title: "My Task Item 10", creationTime: .now - 10000, remindTime: .now + 10020),
//            TaskItem(title: "My Task Item 11", remindTime: .now + 10000),
//            TaskItem(title: "My Task Item 12", completed: false, creationTime: .now)
        ]
    }
}
