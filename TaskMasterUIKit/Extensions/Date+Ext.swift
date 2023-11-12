//
//  Date+Ext.swift
//  TaskMasterUIKit
//
//  Created by mac 2019 on 11/12/23.
//

import Foundation

extension Date{
    
    var asRelativeToNow: String{
        
        let minuteAgo = Calendar.current.date(byAdding: .minute, value: -1, to: .now)!

        if minuteAgo < self {
            return "seconds ago"
        }
        else{
            let formatter = RelativeDateTimeFormatter()
            formatter.unitsStyle = .full

            return formatter.localizedString(for: self, relativeTo: Date.now)
        }
    }

}
