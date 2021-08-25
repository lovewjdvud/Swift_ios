//
//  DBSearchModel.swift
//  Schrodinger
//
//  Created by 임현진 on 2021/07/30.
//

import Foundation
class DBSearchModel: NSObject {
    var pno : String?
    var name : String?
    var category : String?
    var expirationDate : String?
    var memo : String?
    var image : String?
    var updateDate : String?
    var deleteDate: String?
    
    //Empty constructor
    override init() {
        print(19)
    }
    
    init(pno:String,name:String,category:String,expirationDate:String,memo:String,image:String,updateDate:String,deleteDate:String) {
        self.pno = pno
        self.name = name
        self.expirationDate = expirationDate
        self.memo = memo
        self.image = image
        self.updateDate = updateDate
        self.deleteDate = deleteDate
        
    }
}
