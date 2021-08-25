//
//  UseViewController.swift
//  Schrodinger
//
//  Created by 임현진 on 2021/08/02.
//

import Foundation
protocol UseQueryModelProtocol{
    func itemDownloaded(items:NSArray)
}

class UseQueryModel: NSObject {
        var delegate: UseQueryModelProtocol!
        var urlPath = "http://\(Util.shared.api):8080/schrodinger/use_product_query_ios.jsp?\(Util.shared.id)"
        
    func downloadItemed(name:String) -> Bool{
            var result: Bool = true
            let urlAddr = "&name=\(name)"
            urlPath = urlPath + urlAddr

     
            //한글 url encoding
            urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            print(10)
            let url: URL = URL(string: urlPath)!
            let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
            let task = defaultSession.dataTask(with: url){(data, response, error) in
                if error != nil {
                    result = false
                    print("Failed to download data")
                    print(11)
                }else {
                    result = true
                    print("Data is downloaded")
                    self.parseJSON(data!)
                    print(12)
                }
            }
            task.resume() //위에 있는 것은 task의 실행을 하기 위해 정의 된 것이다. task는 data,response,error 세 가지를 가진다.
            return result
        }
        
        func parseJSON(_ data: Data) {
            print(13)
            var jsonResult = NSArray()
            do {
                print(14)
                jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
            } catch let error as NSError {
                print(error)
            } //에러를 잡기 위해 do try catch문을 쓴다.
            
            //제이슨 안에 있는 데이터를 가져온다.
            var jsonElement = NSDictionary()
            print(15)
            //데이터를 넣고 빼고를 할 수 있게 할 수 있도록 Array를 넣음
            let locations = NSMutableArray()
            print(16)
            
            //제이슨 테이블 배열이 2개이므로 jsonResult는 두번 돌아간다.
            for i in 0..<jsonResult.count{
                print(17)
                jsonElement = jsonResult[i] as! NSDictionary
                //String으로 바꾸는 것이 편해서 Default로 지정해놓음
                    if let pno = jsonElement["pno"] as? String,
                       let name = jsonElement["name"] as? String,
                       let category = jsonElement["category"] as? String,
                       let expirationDate = jsonElement["expirationDate"] as? String,
                       let memo = jsonElement["memo"] as? String,
                       let image = jsonElement["image"] as? String,
                       let updateDate = jsonElement["updateDate"] as? String,
                       let deleteDate = jsonElement["deleteDate"] as? String{
                        let query = DBSearchModel(pno: pno, name: name, category: category, expirationDate: expirationDate, memo: memo, image: image, updateDate: updateDate, deleteDate: deleteDate)
                        locations.add(query)
                        print(query)
                }
            }
            //TableViewController에서 다른 일을 하고 있으면 여기서 async를 이용하여 table이 실행 될 때 같이 실행되도록 한다.
            DispatchQueue.main.async(execute: {() -> Void in
                self.delegate.itemDownloaded(items: locations)
                print(18)
            })
        }
}

