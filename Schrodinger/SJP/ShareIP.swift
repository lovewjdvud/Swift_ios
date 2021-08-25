//
//  ShareIP.swift
//  Schrodinger
//
//  Created by 송정평 on 2021/08/02.
//

import Foundation

struct Share {
    
    static var urlIP: String = "http://\(Util.shared.api):8080/schrodinger/"
    static var imageurlIP: String = "http://\(Util.shared.api):8080/schrodinger/images/"
    static var memoMove: String = ""
    static var memoCount: Int = 1
}
