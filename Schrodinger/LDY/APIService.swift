//
//  APIService.swift
//  Schrodinger
//
//  Created by ido on 2021/08/02.
//

import Foundation

class APIService {
    
    let tomcatUserItemURL = "http://\(Util.shared.api):8080/schrodinger/schrodinger_mysql_db.jsp?"
    let tomcatAllItemURL = "http://\(Util.shared.api):8080/schrodinger/schrodinger_all_items_mysql_db.jsp"
    let tomcatRatioItemURL = "http://\(Util.shared.api):8080/schrodinger/schrodinger_throw_mysql_db.jsp?"
    let tomcatCalendarURL = "http://\(Util.shared.api):8080/schrodinger/schrodinger_mysql_db_calendar.jsp?"
    let imageURL = "http://\(Util.shared.api):8080/schrodinger/images/"
    
    
    func performUserItemRequest(completion: @escaping ([Item]) -> Void) {
        
        let session = URLSession(configuration: .default)
        var urlComponents = URLComponents(string: tomcatUserItemURL)!
        
        let idQuery = URLQueryItem(name: "id", value: Util.shared.id)
        
        urlComponents.queryItems?.append(idQuery)
        let requestURL = urlComponents.url!
        print(requestURL)
        session.dataTask(with: requestURL) { data, response, error in
            guard error == nil else {
                return
            }
            
            guard let resultData = data else {
                completion([])
                print("Data is empty")
                return
            }
            let items = APIService.parseItemJSON(resultData)
            completion(items)
            print(items.count)
        }.resume()
        
    }
    
    func performAllItemRequest(completion: @escaping ([ThrowOutItem]) -> Void) {
        
        let session = URLSession(configuration: .default)
        let requestURL = URL(string: tomcatAllItemURL)!
        
        session.dataTask(with: requestURL) { data, response, error in
            guard error == nil else {
                print("Error : \(error?.localizedDescription ?? "Can't find error")")
                return
            }
            
            guard let resultData = data else {
                completion([])
                print("Data is empty")
                return
            }
            let items = APIService.parseThrowOutJSON(resultData)
            completion(items)
        }.resume()
    }
    
    //MARK: Calendar API
    func performCalendarRequest(completion: @escaping ([CalendarItem]) -> Void) {
        
        let session = URLSession(configuration: .default)
        var urlComponents = URLComponents(string: tomcatCalendarURL)!
        
        let idQuery = URLQueryItem(name: "id", value: Util.shared.id)
        
        urlComponents.queryItems?.append(idQuery)
        let requestURL = urlComponents.url!
        print(requestURL)
        session.dataTask(with: requestURL) { data, response, error in
            guard error == nil else {
                return
            }
            
            guard let resultData = data else {
                completion([])
                print("Data is empty")
                return
            }
            
            let items = APIService.parseCalendarJSON(resultData)
            completion(items)
            print(items.count)
        }.resume()
        
    }
//    func pefromRatioItemRequest(completion: @escaping () -> Void) {
//        
//        let session = URLSession(configuration: .default)
//        var urlComponents = URLComponents(string: tomcatRatioItemURL)!
//        
//        let idQuery = URLQueryItem(name: "id", value: "1")
//        
//        urlComponents.queryItems?.append(idQuery)
//        let requestURL = urlComponents.url!
//        session.dataTask(with: requestURL) { data, response, error in
//            guard error != nil else {
//                print("Error : \(error?.localizedDescription)")
//                return
//            }
//            
//            guard let resultData = data else {
//                completion([])
//                print("Data is empty.")
//                return
//            }
//            let items = APIService.
//        }
//    }
    
    static func parseItemJSON(_ data: Data) -> [Item] {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(ResponseItems.self, from: data)
            let items = response.items
            return items
        } catch let error {
            print("Error: \(error.localizedDescription)")
            return []
        }
    }
    
    static func parseThrowOutJSON(_ data: Data) -> [ThrowOutItem] {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(ResponseThorwOutItems.self, from: data)
            let items = response.items
            return items
        } catch let error {
            print("Error: \(error.localizedDescription)")
            return []
        }
    }
    
    static func parseCalendarJSON(_ data: Data) -> [CalendarItem] {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(ResponseCalendarItem.self, from: data)
            let items = response.items
            return items
        } catch let error {
            print("Error: \(error.localizedDescription)")
            return []
        }
    }
//    static func pares(_ data: Data) -> [] {
//        let decoder = JSONDecoder()
//        do {
//            let response = try decoder.decode(.self, from: data)
//            let ratio =
//            return ratio
//        } catch let error {
//            print("Error: \(error.localizedDescription)")
//            return []
//        }
//    }
    
}
