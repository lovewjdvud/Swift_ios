//
//  YHJViewController.swift
//  Schrodinger
//
//  Created by ido on 2021/07/29.
//

import UIKit

class AddItemViewController: UIViewController {
    var itemName : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

// Write 버튼을 눌렀을 때
@IBAction func btnWrite(_ sender: UIButton) {
    
    // Alert 선언
    let alert = UIAlertController(title: "이름 등록", message: "등록할 물건의 이름을 입력해 주세요 :)", preferredStyle: .alert)
    
    let ok = UIAlertAction(title: "확인", style: .default, handler:
                            {ACTION in
                                self.itemName = alert.textFields![0].text!.trimmingCharacters(in: .whitespacesAndNewlines)
                                
                                if(self.itemName.count != 0){
                                    self.performSegue(withIdentifier: "sgWrite", sender: self)
                                }else{ }
                            })
    
    ok.isEnabled = false
    
    let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
    
    // adding the notification observer here
    
    alert.addAction(ok)
    alert.addAction(cancel)
    alert.addTextField{ (textField) -> Void in
        textField.placeholder = "이름"
        // 내장 텍스트뷰에 타겟을 심어 alertController로 전송, 빈칸 여부에 따라 첫번째 액션, 확인 액션의 활성 여부를 결정.
        textField.addTarget(alert, action:
                                #selector(alert.didTextChangeInputDialog), for: UIControl.Event.editingChanged)
    }
    present(alert, animated: true, completion: nil)
}// btnWrite

// Segue 선언
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    // Write segue
    if segue.identifier == "sgWrite"{
        
        let addItemDetailViewController = segue.destination as! AddItemDetailViewController
        
        addItemDetailViewController.itemName = itemName
        present(addItemDetailViewController, animated: true, completion: nil)
    }
    
    // Barcode segue
    if segue.identifier == "sgBarcode"{
        
        let readerViewController = segue.destination as! ReaderViewController
        
        present(readerViewController, animated: true, completion: nil)
    }
}

} // AddItemViewController


extension UIAlertController {
    
    @objc func didTextChangeInputDialog(_ sender : UITextField){
        
        if (sender.text?.count == 0){
            
            self.actions[0].isEnabled = false
        }else {
            self.actions[0].isEnabled = true
        }
    }
    
}
