//
//  QueryThrow.swift
//  Schrodinger
//
//  Created by 송정평 on 2021/08/02.
//

import Foundation

protocol QueryThrowProtocol{
    func DetailTrowitemDownloaded(items: NSMutableArray , locationcont: Int)
}


class QueryThrow{
 
    var delegate: QueryThrowProtocol!
    var urlPath = "\(Share.urlIP)DetailThrow_song.jsp"
    
    func DetailThrowdownloadItems(pname: String, u_user_no: String){
        let urlAdd = "?pname=\(pname)&u_user_no=\(u_user_no)"
        
        urlPath = urlPath + urlAdd
        print("\(urlPath) 여기는 QueryThrow")
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
       
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession.init(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url){(data, response, error) in
            if error != nil{
                print("Failed to download data")
            }else{
                print("Data is downloaded")
                self.parseJSON(data!)
            }
            
        }
        
        task.resume()
    }
   
    func parseJSON(_ data: Data) {
        var jsonResult = NSArray()
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        }catch let error as NSError{
            print(error)
        }
        
        var jsonElement = NSDictionary()
        let locations = NSMutableArray()
        
        for i in 0..<jsonResult.count{
            jsonElement = jsonResult[i] as! NSDictionary

            if let throwDate = jsonElement["count"] as? String
            {
                let query = DBDetailModel(throwDate: throwDate)
                locations.add(query)
            }
        }
        let locationcont  =  locations.count
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.DetailTrowitemDownloaded(items: locations , locationcont: locationcont)
        })
    }
}


