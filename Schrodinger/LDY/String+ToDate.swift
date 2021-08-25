//
//  String+ToDate.swift
//  Schrodinger
//
//  Created by Doyoung on 2021/08/04.
//

import Foundation

extension String {
    func toDate() -> Date {
        let formatter = DateFormatter()
        
        formatter.dateStyle = .short
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter.date(from: self)!
    }
}
