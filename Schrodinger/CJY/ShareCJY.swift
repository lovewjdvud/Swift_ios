//
//  ShareCJY.swift
//  Schrodinger
//
//  Created by Jiyeon on 2021/08/03.
//

import Foundation

struct ShareCJY {
    
    func url(_ fileName: String) -> String{
        let url = "http://\(Util.shared.api):8080/schrodinger/\(fileName)?id=\(Util.shared.id)"
        return url
    }
    
    func imgUrl(_ fileName: String) -> String{
        let url = "http://\(Util.shared.api):8080/schrodinger/images/\(fileName)?id=\(Util.shared.id)"
        return url
    }
}
