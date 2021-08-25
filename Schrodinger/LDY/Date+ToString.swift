//
//  Date+ToString.swift
//  Schrodinger
//
//  Created by Doyoung on 2021/08/04.
//

import Foundation

extension Date {
    
    func toString(format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        
        return formatter.string(from: self)
    }
    
    func beforeOneWeek() -> Date {
        return Calendar.current.date(byAdding: .day, value: -7, to: self)!
    }
}
