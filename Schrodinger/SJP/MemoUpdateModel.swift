//
//  MemoUpdate.swift
//  Schrodinger
//
//  Created by 송정평 on 2021/08/05.
//

import Foundation

class MemoUpdateModel{
    //jsonmodel 이 portocol 을 가지고 잇어야 함!?
   
    var urlPath = "\(Share.urlIP)MemoUpdate.jsp"
    
    func MemoUpdateItems(pno: Int, memo: String) -> Bool{
        var result: Bool = true
        let urlAdd = "?pno=\(pno)&memo=\(memo)"
        
        urlPath = urlPath + urlAdd // urlpath는 진짜 URL
        //한글 url encoding
        print("\(urlPath) 여기는 MemoUpdateModel")
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        // 서버에서 데이터 받아오는 동안 다른 일을 해야지!
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession.init(configuration: URLSessionConfiguration.default) //Foundation은 지워도 된다
        let task = defaultSession.dataTask(with: url){(data, response, error) in
            if error != nil{
                print("Failed to insert data")
                result = false
            }else{
                print("Data is insert") // 다운로드 된거로 json 으로 감?
                result = true
            }
            
        }
        
        task.resume() //resume을 실해하면 json으로 데이터를 가져온다
        return result
    }
}
