//
//  ReaderViewController.swift
//  Schrodinger
//
//  Created by HyeonJoonYang on 2021/07/30.
//

import UIKit
import AVFoundation
//import SwiftSoup

class ReaderViewController: UIViewController {
//    
//    // 각종 변수 선언
//    var strItemName : String = ""
//    var strItemExpireDate : String = ""
//    @IBOutlet weak var readerView: ReaderView!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        self.readerView.delegate = self
//        
//        // 0809 바코드 기능
//        self.readerView.start()
//    }
//    
//    // 뷰가 꺼지는 도중 readerView 기능 종료
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        
//        if !self.readerView.isRunning {
//            self.readerView.stop(isButtonTap: false)
//        }
//    }
//    
//    // webCrawling (SwiftSoup)
//    func doCrawlingText(code : String) {
//        
//        let Barcode = code
//        let idKey : String = "f35b8b370050494daeae" // API KEY
//        let startNum : Int = 1 // 검색 시작 번호
//        let endNum : Int = 1000 // 검색 끝 번호 (1000 단위로 검색 가능)
//        
//        let urlAddress = URL(string: "https://openapi.foodsafetykorea.go.kr/api/\(idKey)/C005/xml/\(startNum)/\(endNum)/BAR_CD=\(Barcode)")
//        
//        guard let myUrl = urlAddress else { return }
//        do {
//            let myUrlStr = try String(contentsOf: myUrl, encoding: .utf8)
//            let doc: Document = try SwiftSoup.parse(myUrlStr)
//            
//            // PRDLST_NM(제품 명), POG_DAYCNT(유통기한) 태그 정보를 저장
//            let resultName : Elements = try doc.select("row#0").select("PRDLST_NM")
//            let resultExpireDate : Elements = try doc.select("row#0").select("POG_DAYCNT")
//            
//            strItemName = try resultName.text()
//            strItemExpireDate = try resultExpireDate.text()
//            
//        } catch Exception.Error(let type, let message) {
//            print("Message : \(message)")
//        } catch {
//            print("error")
//        }
//        
//    }// doCrawlingText
//
//}//ReaderViewController
//
//
//extension ReaderViewController: ReaderViewDelegate {
//    
//    func readerComplete(status: ReaderStatus) {
//        
//        var title = ""
//        var message = ""
//        switch status {
//        
//        // #1. 스캔 성공 시
//        case let .success(code):
//            guard let code = code else {
//                title = "에러"
//                message = "QR코드 or 바코드를 인식하지 못했습니다.\n다시 시도해주세요."
//                break
//            }
//            
//            // 0810 크롤링 기능
//            doCrawlingText(code: code)
//            
//            // 제품 명 결과가 없을 때
//            if strItemName.isEmpty{
//                // 메세지 출력 후, 화면을 종료.
//                let alert = UIAlertController(title: "검색 실패", message: " 바코드 검색에 실패했습니다. :( \n '직접입력' 버튼을 눌러 진행해 주세요!", preferredStyle: .alert)
//                
//                let ok = UIAlertAction(title: "확인", style: .default, handler:
//                                        {ACTION in self.dismiss(animated: true) })
//                alert.addAction(ok)
//                self.present(alert, animated: true, completion: nil)
//                
//            } else {
//                // read성공
//                title = ""
//                message = "인식 성공!\n 등록 화면으로 넘어갑니다."
//            }
//            
//        // #2. 스캔 실패 시
//        case .fail:
//            title = "에러"
//            message = "QR코드 or 바코드를 인식하지 못했습니다.\n다시 시도해주세요."
//            
//        // 스캔 중단 시
//        case let .stop(isButtonTap):
//            if isButtonTap {
//                title = "알림"
//                message = "바코드 읽기를 멈추었습니다."
//            } else {
//                return
//            }
//        }
//        
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        
//        let okAction = UIAlertAction(title: "확인", style: .default, handler: {ACTION in
//            
//            // 0809 수정 : 확인 클릭 시 값을 넘겨 주며 화면 이동
//            if let addItemDetailViewController =  self.storyboard?.instantiateViewController(identifier: "idAddItemDetailViewController") as? AddItemDetailViewController
//            {
//                // 값을 넘겨주며 화면 종료
//                guard let pvc = self.presentingViewController else {return}
//                addItemDetailViewController.itemName = self.strItemName
//                addItemDetailViewController.itemExpirationDate = self.strItemExpireDate
//                
//                self.dismiss(animated: true) {
//                    pvc.present(addItemDetailViewController, animated: true, completion: nil)
//                }
//            }
//        })
//        
//        alert.addAction(okAction)
//        self.present(alert, animated: true, completion: nil)
//    }// readerComplete
    
}// extension ReaderViewController

// 0812 이미지 크롤링 테스트 용
//        let urlAddress = URL(string: "https://search.shopping.naver.com/catalog/22708826001?query=메로나&NaPm=ct%3Dks9sohtk%7Cci%3D52fc96c1557e6c8cf394982b4ce5e9b7b8c5260b%7Ctr%3Dslsl%7Csn%3D95694%7Chk%3D6f3706255528963722a19d40da43478dc195300a")
//
//        guard let myUrl = urlAddress else { return }
//
//        do{
//            let myUrlStr = try String(contentsOf: myUrl, encoding: .utf8)
//            let doc: Document = try SwiftSoup.parse(myUrlStr)
//
//            let imagesrc: Elements = try doc.select("div#islrg").select("div.islrc").select("div[data-ri=\"0\"").select("a.wXeWr.islib.nfEiy").select("div.bRMDJf.islir").select("img[src]")
//            let stringImage = try imagesrc.attr("src").description
//            let urlImage = URL(string: stringImage)
//            let data = try Data(contentsOf: urlImage!)
//
//            ivTest.image = UIImage(data: data)
//
////            // 이미지 있는지 여부 체크
////            if ivTest.image = UIImage(data: data)
//
//        } catch Exception.Error(let type, let message) {
//            print("Message : \(message)")
//        } catch {
//            print("error")
//        }
