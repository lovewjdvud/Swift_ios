//
//  MyPageViewController.swift
//  Schrodinger
//
//  Created by IanKim on 2021/08/02.
//

import UIKit
import KakaoSDKUser // MARK: Kakao Login - Logout, 연결 끊기
import Firebase // MARK: Google Login - Firebase 초기화
import GoogleSignIn


class MyPageViewController: UIViewController {
    
    @IBOutlet weak var infoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        infoLabel.text = Share.userID
//        infoLabel.text = UserDefaults.standard.string(forKey: "userEmail")
        // MARK: Email UserDefault Label에 띄우기
        infoLabel.text = myUserDefaults.string(forKey: "userEmail")
        
        // MARK: userEmailInsert 실행
        self.userEmailInsert(myUserDefaults.string(forKey: "userEmail")!)
        
        // MARK: userNumberQuery 실행
        self.userNumberQuery()
        
        
    }
    
    
    @IBAction func btnLogOut(_ sender: UIButton) {
        // MARK: Kakao Login - Logout
//        UserApi.shared.logout {(error) in
//            if let error = error {
//                print(error)
//            }
//            else {
//                print("logout() success.")
//                self.dismiss(animated: true)
//            }
//        }
        // MARK: 로그인 공통 - userno UserDefault 확인
        print("userno = \(String(describing: usernoUserDefaults.string(forKey: "userno")))")
        infoLabel.text = usernoUserDefaults.string(forKey: "userno")
        
        // MARK: Kakao Login - Logout, 연결 끊기
        UserApi.shared.unlink {(error) in
            if let error = error {
                print(error)
            }
            else {
                print("unlink() success.")
                self.dismiss(animated: true)
//                Share.userID = "방문자"

            }
        }
        myUserDefaults.set("방문자", forKey: "userEmail")
        
        // MARK: Google Login - LogOut
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.dismiss(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
      
        
    }
    
    // MARK: 로그인 공통 - user email 받아 DB에 입력
    func userEmailInsert(_ id: String) {
        print("id to insert in userEmailInsert func = \(id)")
        if myUserDefaults.string(forKey: "userEmail") != "방문자" {
//            let id = myUserDefaults.string(forKey: "userEmail")
            
            let userInsertModel = UserInsertModel()
            let result = userInsertModel.insertItems(id: id)
            
            if result{
                print("입력 완료 - email : \(String(describing: myUserDefaults.string(forKey: "userEmail")))")
    //            let resultAlert = UIAlertController(title: "완료", message: "입력이 되었습니다!", preferredStyle: .alert)
    //            let onAction = UIAlertAction(title: "OK", style: .default, handler: { ACTION in
    //                self.navigationController?.popViewController(animated: true)
    //            })
    //
    //            resultAlert.addAction(onAction)
    //            present(resultAlert, animated: true, completion: nil)
                
            }else{
                print("에러 발생 - email : \(String(describing: myUserDefaults.string(forKey: "userEmail")))")
    //            let resultAlert = UIAlertController(title: "실패", message: "에러가 발생 되었습니다!", preferredStyle: .alert)
    //            let onAction = UIAlertAction(title: "OK", style: .default, handler: { ACTION in
    //                self.navigationController?.popViewController(animated: true)
    //            })
    //
    //            resultAlert.addAction(onAction)
    //            present(resultAlert, animated: true, completion: nil)
            }
            
        } else{
            return
        }

    }
    
    // MARK: 로그인 공통 - user email(id) 이용해 DB에서 user number(userno) 가져와 user default에 등록
    func userNumberQuery() {
        print("id to download userno in userNumberQuery func = \(String(describing: myUserDefaults.string(forKey: "userEmail")))")
        let queryModel = UserQueryModel()
        queryModel.downloadItems(id: myUserDefaults.string(forKey: "userEmail")!)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
