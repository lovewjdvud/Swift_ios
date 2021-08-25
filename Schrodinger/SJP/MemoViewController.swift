//
//  MemoViewController.swift
//  Schrodinger
//
//  Created by 송정평 on 2021/08/02.
//

import UIKit

class MemoViewController: UIViewController {

    @IBOutlet weak var D_tv_Memomain: UITextView!
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
//    memoUpdate()
    //메모 업데이트
//    func memoUpdate()  {
//        let memoUpdateModel = MemoUpdateModel()
//        let result = memoUpdateModel.MemoUpdateItems(pno: receivepno, memo: MemoSend)
//        resultAlert(result: result)
//        self.navigationController?.popViewController(animated: true)
//    }
    
    var preparememo = ""
    var delegate: MemoEdit?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        D_tv_Memomain.becomeFirstResponder()
        Share.memoCount = 1
        D_tv_Memomain.text = "\(preparememo)"
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        shadowView.layer.shadowOffset = .zero
        shadowView.layer.shadowRadius = 6
        shadowView.layer.shadowOpacity = 0.1
        shadowView.layer.masksToBounds = false
    }
    
    @IBAction func M_btn_memoUpdate(_ sender: UIBarButtonItem) {
      
     
        if delegate != nil{
            delegate?.didMessageEditDone(self, message: D_tv_Memomain.text) // viewcontroller의 함수를         }
            navigationController?.popViewController(animated: true) // 화면 보내는 친구
        }
       
        
    }
    //Keyboard만큼 올라오기
    @objc func adjustInputView(noti: Notification) {
        guard let userInfo = noti.userInfo else { return }
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as?
                                    NSValue)?.cgRectValue else { return }
        if noti.name == UIResponder.keyboardWillShowNotification {
            let adjustMentHeight = keyboardFrame.height
            bottomConstraint.constant = adjustMentHeight + 20
        }
    }
//    //MARK: 메모 클릭시 이벤트
//    @objc func viewMapTapped(sender: UITapGestureRecognizer) {
//
//        if delegate != nil{
//            delegate?.didMessageEditDone(self, message: D_tv_Memomain.text) // viewcontroller의 함수를 실행시켜준다
//
//        }
//        navigationController?.popViewController(animated: true) // 화면 보내는 친구
    }
    
        
      
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */



