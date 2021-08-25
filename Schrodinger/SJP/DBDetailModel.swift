//
//  DBDetailModel.swift
//  Schrodinger
//
//  Created by 송정평 on 2021/08/02.
//

import Foundation

class DBDetailModel: NSObject{
   
    var pname: String?
    var throwDate: String?
    var update: String?
    var memo: String?
    var submitDate: String?
    var expirationDate: String?
    var image: String?
    var useCompletionDate: String?
    
    override init() {
        
    }
    
   
    
    init(pname: String, memo: String , expirationDate: String, image: String) {
        self.pname = pname
        self.memo = memo
        self.expirationDate = expirationDate
        self.image = image
    }
    
    init(throwDate: String) {
     self.throwDate = throwDate
 
 }
    
    init(submitDate: String) {
     self.submitDate = submitDate
 
 }
    
    init(throwDate: String,useCompletionDate: String) {
     self.throwDate = throwDate
    self.useCompletionDate = useCompletionDate
 
 }
    
}//class

