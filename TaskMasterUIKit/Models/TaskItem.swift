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
    var notes: String
    var remind: Bool = true
    var completed: Bool = false
    var creationTime: Date = .now
    var lastEditTime: Date? = nil
    
    static var dummies: [TaskItem]{
        [
            TaskItem(title: "My Task Item", notes: ""),
            TaskItem(title: "My Task Item 2", notes: "", completed: true),
            TaskItem(title: "My Task Item 3", notes: "", remind: false, creationTime: Calendar.current.date(byAdding: .second, value: 11, to: .now)!),
            TaskItem(title: "My Task Item 4", notes: "Note for task item 4"),
            TaskItem(title: "My Task Item 5", notes: "", remind: true, lastEditTime: Calendar.current.date(byAdding: .minute, value: -30, to: .now))
        ]
    }
}

extension TaskItem{
    var addOrLastEditTime: String{
        if let lastEditTime{
            return "Last edited \(lastEditTime.asRelativeToNow)"
        }
        
        return "Added \(creationTime.asRelativeToNow)"
    }
}
