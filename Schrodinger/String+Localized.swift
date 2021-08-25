//
//  String+Localized.swift
//  Schrodinger
//
//  Created by ido on 2021/07/29.
//

import Foundation

extension String {
    
    var localized: String {
        return NSLocalizedString(self, tableName: "Localizable", value: self, comment: "")
    }
    
}
