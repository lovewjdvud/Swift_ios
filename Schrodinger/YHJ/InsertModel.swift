//
//  InsertModel.swift
//  Schrodinger
//
//  Created by HyeonJoonYang on 2021/08/03.
//

import Foundation

//insert는 protocol이 필요없음
class InsertModel{
    //jsonmodel 이 portocol 을 가지고 있음
   
    var urlPath = "http://\(Util.shared.api):8080/schrodinger/schrodingerInsert_ios.jsp"
    
    func insertItems(name: String, category: String, expirationdate: String, memo: String, image: String) -> Bool {
        
        var result: Bool = true
        let urlAdd = "?name=\(name)&category=\(category)&expirationdate=\(expirationdate)&memo=\(memo)&image=\(image)&updateDate=now()" // 띄어쓰기하면 안됨!
        urlPath = urlPath + urlAdd
        
        // 한글 url encoding
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)! // 한글이 %로 쫙!
        
        // 서버에서 데이터 받아오는 동안
        let url: URL = URL(string: urlPath)!
        let defaultSession = URLSession.init(configuration: URLSessionConfiguration.default) //Session만듬, Foundation 안써도 됨!
        
        let task = defaultSession.dataTask(with: url){(data, response, error) in
            // data, response, error 타입
            //서버에서 신호주는거: response, 브라우저에서 신호주는것: request
            if error != nil{
                print("Failed to insert data")
                result = false
            }else{
                print("Data is Inserted")
                result = true
                
            }
            
        }
        // resume 위에 url, defaultSission, task 는 선언임
        //task 실행
        task.resume()
        return result
    }

}//-----
