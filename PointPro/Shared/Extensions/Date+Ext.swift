//
//  Date+Ext.swift
//  PointPro
//
//  Created by Carlos Suarez on 5/6/25.
//

import Foundation

extension Date {
    var shortFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: self)
    }
}
