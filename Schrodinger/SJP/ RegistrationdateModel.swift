//
//   Registrationdate.swift
//  Schrodinger
//
//  Created by 송정평 on 2021/08/05.
//

import Foundation

protocol  RegistrationdateProtocol{
    func RegistrationdateitemDownloaded(items: NSMutableArray , locationcont: Int) // data를 NSArray로 만들겠다! : NS : Next Step - 전통적인 방법
}


class  RegistrationdateModel{
    //jsonmodel 이 portocol 을 가지고 잇어야 함!?
    var delegate: RegistrationdateProtocol! // data를 받아오는걸 연결하나!? ___ 나
    var urlPath = "\(Share.urlIP)Registration.jsp"
    
    
    // 여기서 pid값을 받아온다
    func RegistrationdatedownloadItems(s_product_no: Int, s_user_no: String){
       
        print("\(s_product_no) QueryPurchase 여기는 이름값이 잘들어갔는지 확인하는 곳")
        print("\(s_user_no) QueryPurchase 여기는 u_user_no값이 잘들어갔는지 확인하는 곳")
        let urlAdd = "?s_product_no=\(s_product_no)&s_user_no=\(s_user_no)"
        
        urlPath = urlPath + urlAdd // urlpath는 진짜 URL
        print("\(urlPath) 여기는 Registration")
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        // 서버에서 데이터 받아오는 동안 다른 일을 해야지!
        
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession.init(configuration: URLSessionConfiguration.default) //Foundation은 지워도 된다
        let task = defaultSession.dataTask(with: url){(data, response, error) in
            if error != nil{
                print("Failed to download data")
            }else{
                print("Data is downloaded") // 다운로드 된거로 json 으로 감?
                self.parseJSON(data!) // 파싱을 만들자
            }
            
        }
        
        task.resume() //resume을 실해하면 json으로 데이터를 가져온다
    }
    
    //어싱크 방식 은 dispatch 가 들어감
    func parseJSON(_ data: Data){
        var jsonResult = NSArray()
        do{
            //swift 에서 json 쓰는 방법
            jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
            //JSONSerialization.ReadingOptions 는 더블클릭!
            //NSArray 가 변환이 쉬워서 [] 임
        }catch let error as NSError{
            print(error)
        }
        
        var jsonElement = NSDictionary()  // json이 dictionary 모양이기 때문이다!
        let locations = NSMutableArray()  // : ArrayList 라고 생각하면됨! <> NSArray
        
        for i in 0..<jsonResult.count{// 결과를 한 묶음씩 알고있음
            jsonElement = jsonResult[i] as! NSDictionary // jsonElement 가 NSDictionary 이므로
            //왜 딕셔너리? json 파일이 변수명 : 값 으로 구성되어 있으므로
            //집어넣기
            if let submitDate = jsonElement["submitDate"] as? String
              
               // json 에 있는 dept 키의 값을 가져옴
               
            {
                
                //DBModel 로 Bean (데이터 받아서 _ 생성자 만들었었음)
                print("\(submitDate)")
                let query = DBDetailModel.init(submitDate: submitDate)
                locations.add(query)
                print("\(query) 여기는 Registration에서 테스트 ")
               
                
            }
    
        }
        let locationcont  =  locations.count
        print("\(locationcont) 여기는 Registration 집합의 카운트를 세는 곳이야")
//        print("\(locations)여기는 QueryModel에서 가져온 값들")
//        //테이블 뷰도 실행되지만 얘도 동시에 실행되어야함 _ 어싱
//
//        if delegate == nil{
//            print("닐값")
//        }else{
        
        //print("\(delegate) 여기는 delegate 확인하는곳")
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.RegistrationdateitemDownloaded(items: locations , locationcont: locationcont)
        })
        
    
    }
}


