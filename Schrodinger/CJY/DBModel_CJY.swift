//
//  DBModel_CJY.swift
//  Schrodinger
//
//  Created by Jiyeon on 2021/08/03.
//

import Foundation

class DBModel: NSObject{
    var pno: Int?
    var name: String?
    var expirationDate: String?
    var image: String?
    
    // 서버에 올리므로 이미지도 string? UIImage가 아니라?
    
    // MARK: Empty constructor
    override init() {
        
    }
    
    // 생성자 만듦
    init(pno: Int, name: String, expirationDate: String, image: String) {
        self.pno = pno
        self.name = name
        self.expirationDate = expirationDate
        self.image = image
    }
}
