//
//  CosmeticsAllModel.swift
//  Schrodinger
//
//  Created by Jiyeon on 2021/08/05.
//

import Foundation

// MARK: protocol CosmeticsAllModelProtocol
protocol CosmeticsAllModelProtocol{
    
    func itemDownloaded(items: NSMutableArray) // 배열 만드는 것 NSArray(NS = Next Step)
    
}


// MARK: CosmeticsAllModel class
class CosmeticsAllModel{
    var delegate: CosmeticsAllModelProtocol!
    var urlPath = share.url("cosmetics_all_schrodinger.jsp")
    
    func downloadItems(check: String) {
        urlPath = urlPath + "&check=\(check)"
        let url: URL = URL(string: urlPath)!
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url){(data, response, error) in
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.delegate.itemDownloaded(items: [])
                }
                return
            }
                print("Data is download")
            self.parseJSON(data) // 데이터 받아서 파싱해주는 것
            
        }
        task.resume()
    }
    
    
    // 파싱 만들기
    func parseJSON(_ data: Data){
        var jsonResult = NSArray()
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
            
        }catch let error as NSError{
            print("Error: \(error.localizedDescription)")
        }
        
        var jsonElement = NSDictionary()
        let locations = NSMutableArray() // ArrayList..
        print(jsonResult.count)
        if jsonResult.count != 0 {
            for i in 0..<jsonResult.count{
                jsonElement = jsonResult[i] as! NSDictionary
                if let pno = jsonElement["pno"] as? String, // JSON은 무조건 String, 따라서, jsp에서 Int가 "" 감싸져 있다면 int라도 String으로
                   let name = jsonElement["name"] as? String,
                   let expirationDate = jsonElement["expirationDate"] as? String,
                   let image = jsonElement["image"] as? String{
                    let query = DBModel(pno: Int(pno)!, name: name, expirationDate: expirationDate, image: image)
                    locations.add(query)
                    print(pno, name, expirationDate, image)
                }
            }
            DispatchQueue.main.async(execute: {() -> Void in
                self.delegate.itemDownloaded(items: locations)
            })
        }
        
    }
}

