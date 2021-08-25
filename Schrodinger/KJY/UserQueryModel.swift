//
//  UserQueryModel.swift
//  Schrodinger
//
//  Created by IanKim on 2021/08/03.
//

import Foundation

//protocol QueryModelProtocol{ // : class, : AnyObject
//    func itemDownloaded(items: NSArray) // NS : next step
//}

class UserQueryModel{ // : NSObject
    
//    var delegate: QueryModelProtocol!
    
    var urlPath = "http://\(Util.shared.api):8080/schrodinger/user_query_ios.jsp"
    
    // MARK: query 실행
    func downloadItems(id: String) {
        
        let urlAdd = "?id=\(id)"
        urlPath = urlPath + urlAdd
        print("id to download userno in UserQueryModel class = \(id)")
        
        // 한글 url encoding
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        let url: URL = URL(string: urlPath)!
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default) // Foundation.URLSession... 가능
        let task = defaultSession.dataTask(with: url){(data, responds, error) in
            if error != nil{
                print("Failed to download data")
            }else{
                print("Data is downloaded")
                
                // MARK: query 결과(userno) 받아 userno User Default에 등록
                usernoUserDefaults.set(self.parseJSON(data!), forKey: "userno")
            }
        }
        task.resume()
    }
    
    // MARK: query 결과 받아오기
    func parseJSON(_ data: Data) -> String {
        
        // MARK: 단일 값 받아오므로 NSArray 아닌 NSString으로 받기
        var jsonResult = NSString() // NSArray 로 변환이 쉬움
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSString
            print("jsonResult = \(jsonResult)")
        }catch let error as NSError{
            print(error)
        }
        return jsonResult as String
//
//        var jsonElement = NSDictionary()
//        let locations = NSMutableArray()
//
//        for i in 0..<jsonResult.count{
//            jsonElement = jsonResult[i] as! NSDictionary // JSON은 Dictionary 형태이므로 많이 씀
//            if let scode = jsonElement["code"] as? String,
//               let sname = jsonElement["name"] as? String,
//               let sdept = jsonElement["dept"] as? String,
//               let sphone = jsonElement["phone"] as? String{
//                let query = DBModel(scode: scode, sname: sname, sdept: sdept, sphone: sphone)
//                locations.add(query)
//            }
//        }
//        DispatchQueue.main.async(execute: {() -> Void in // async : tableview가 화면 띄울때 데이터 같이 넘겨 줄 수 있음
//            self.delegate.itemDownloaded(items: locations)
//        })
    }
}
