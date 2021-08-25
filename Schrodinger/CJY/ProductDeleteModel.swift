//
//  ProductDeleteModel.swift
//  Schrodinger
//
//  Created by Jiyeon on 2021/08/05.
//

import Foundation

var share = ShareCJY()

class ProductDeleteModel{
    var urlPath = share.url("product_delete_schrodinger.jsp")
    
    
    // 함수 이름 바꿈 -> 괄호 안에 데이터 넣어줌(code: String, name: String, dept: String, phone: String)
    // 리턴 값 쓸 일이 있으므로 "-> Bool" 해 줌
    // MARK: *** 함수는 소문자! 클래스는 대문자! *** 얘는 이거 예민해서 틀리면 에러뜬다!!!!!
    func deleteItems(pno: Int) -> Bool{
        var result: Bool = true
        let urlAdd = "&pno=\(pno)"
        print(pno)
        // ?는 urlPath 안에 있는 주소 맨 뒤에 달려서 나감, 띄어쓰기 안 돼!
        urlPath = urlPath + urlAdd
        print(urlPath)
        
        // 한글 url encoding -> 한글이 퍼센트 글자로 쫙 바뀌어서 urlPath가 만들어진다.
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        let url: URL = URL(string: urlPath)!
       // let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url){(data, response, error) in
            if error != nil{
                print("Failed to delete data")
                result = false
            }else{
                print("Data is deleted!")
                // 파싱은 없고 잘 끝났다는 걸 표시 (result로)
                result = true
            }
            
        }
        task.resume()
        return result
    }
    
}

