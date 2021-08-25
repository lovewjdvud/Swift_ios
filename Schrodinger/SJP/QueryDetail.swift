//
//  QueryDetail.swift
//  Schrodinger
//
//  Created by 송정평 on 2021/08/02.
//

import Foundation


protocol QueryDetailProtocol{
    func itemDownloaded(items: NSMutableArray , locationcont: Int)
}


class QueryDetail{
    
    var delegate: QueryDetailProtocol!
    var urlPath = "\(Share.urlIP)Detail_song.jsp"
   
    func DetaildownItems(pno: Int){
        let urlAdd = "?pno=\(pno)"
        urlPath = urlPath + urlAdd
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        print("URL is : \(urlPath)")
        let url: URL = URL(string: urlPath)!
        let defaultSession = URLSession(configuration: .default)
        let task = defaultSession.dataTask(with: url){data, response, error in
            if error != nil{
                print("Failed to download data")
            }else{
                self.parseJSON(data!)
            }
            
        }
        
        task.resume() //resume을 실해하면 json으로 데이터를 가져온다
    }
    
    //어싱크 방식 은 dispatch 가 들어감
    func parseJSON(_ data: Data) {
        var jsonResult = NSArray()
        do{
            //swift 에서 json 쓰는 방법
            jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        }catch let error as NSError{
            print(error)
        }
        
        var jsonElement = NSDictionary()
        let locations = NSMutableArray()
        
        for i in 0..<jsonResult.count{
            jsonElement = jsonResult[i] as! NSDictionary
            if let name = jsonElement["name"] as? String,
               let memo = jsonElement["memo"] as? String,
               let expirationDate = jsonElement["expirationDate"] as? String,
               let image = jsonElement["image"] as? String
            {
                let query = DBDetailModel(
                    pname: name,
                    memo: memo,
                    expirationDate: expirationDate,
                    image: image)
                locations.add(query)
            } else {
                print("DATA is nil")
            }
            
        }
        let locationcont  =  locations.count
        
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.itemDownloaded(items: locations , locationcont: locationcont)
        })
        
    }
}


