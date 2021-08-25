//
//  UserInsertModel.swift
//  Schrodinger
//
//  Created by IanKim on 2021/08/03.
//

import Foundation

class UserInsertModel{ // : NSObject
    
    var urlPath = "http://\(Util.shared.api):8080/schrodinger/userInsert_ios.jsp"
    
    // MARK: insert 실행
    func insertItems(id: String) -> Bool{
        var result: Bool = true
        let urlAdd = "?id=\(id)"
        urlPath = urlPath + urlAdd
        print("id to insert in UserInsertModel class = \(id)")
        
        // 한글 url encoding
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        let url: URL = URL(string: urlPath)!
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default) // Foundation.URLSession... 가능
        let task = defaultSession.dataTask(with: url){(data, responds, error) in
            if error != nil{
                print("Failed to insert data")
                result = false
            }else{
                print("Data is inserted")
                result = true
            }
        }
        task.resume()
        return result
    }
    

}
