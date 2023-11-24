//
//  Date+Ext.swift
//  TaskMasterUIKit
//
//  Created by mac 2019 on 11/12/23.
//

import Foundation

extension Date{
    var asRelativeToNow: String{
        
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        
        return formatter.localizedString(for: self, relativeTo: Date.now)
    }
}
