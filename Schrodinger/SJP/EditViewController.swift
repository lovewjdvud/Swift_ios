//
//  EdictViewController.swift
//  Schrodinger
//
//  Created by 송정평 on 2021/08/03.
//

import UIKit

class EdictViewController: UIViewController {

    var imageFilepath = "" //넘어온 이미지 파일 주소
    var receivepno = 1// 디테일뷰에서 넘어올때 물건 pk
    var Shelflife_Editdate = "" //수정하고 싶은 유통기한 날짜
    
    @IBOutlet weak var E_imageView: UIImageView!
    
    @IBOutlet weak var test: UILabel!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //이미지 띄우기
        let url = URL(string: "\(imageFilepath)")
        let data = try? Data(contentsOf: url!)
        E_imageView.image = UIImage(data: data!)
       
        // Do any additional setup after loading the view.
    }
    


    @IBAction func E_Picker_Shelflife(_ sender: UIDatePicker) {
        
            let datePickerView = sender
            let formatter = DateFormatter()
            
            formatter.locale = Locale(identifier: "ko")
          //  formatter.dateFormat =  "yyyy-MM-dd a hh:mm"  //24시간 HH
            formatter.dateFormat =  "yyyy-MM-dd"  //24시간 HH

        
            Shelflife_Editdate = "\(formatter.string(from: datePickerView.date))"
         
    }
    
    // 유통기한 날짜 업데이트하기 위한 날짜
    
    @IBAction func E_btn_Shellife(_ sender: UIButton) {
     //   let testAlert = UIAlertController(title: "Edit Item", message: "Do you change shelf life date? ", preferredStyle: .alert)
        
        if Shelflife_Editdate != ""{
        //Action
        let Edict = UIAlertController(title: "Edit Item", message: "Do you change shelf life date? ", preferredStyle: .alert)
        
    
        let EdicCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let Edictallow = UIAlertAction(title: "Edict", style: .destructive, handler:  { [self]ACTION in Shelflife_update()})
 //       let lampOnAction = UIAlertAction(title: "아니요 켭니다", style: .default, handler: { [self]ACTION in nil})
     
      //  EdictCancel.setValue(UIColor(red: CGFloat(GL_RED), green: nil, blue: nil, alpha: nil), forKey: "title")
              
               // lampremove.addAction(lampOnAction)
        Edict.addAction(Edictallow)
        Edict.addAction(EdicCancel)
      
                present(Edict, animated: true, completion: nil)
            
        }else if Shelflife_Editdate == ""{
            let Edict = UIAlertController(title: "경고", message: "날짜를 입력주세요", preferredStyle: .alert)
            let EdicCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            Edict.addAction(EdicCancel)
            present(Edict, animated: true, completion: nil)
            
        }
        
            }
    
    
    
    
    
    
    
    
    
    
    
    
    // 수정한 데이트 업로드하는 함수
    func Shelflife_update()  {
        
       let ShelflifeUpdateModel = EditShelflifeUpdateModel()
   
        
        let result =  ShelflifeUpdateModel.ShelflifeUpdateItems(pno: receivepno, expirationDate: Shelflife_Editdate)
         if result{
             
             let resultAlert = UIAlertController(title: "완료", message: "수정되었습니다", preferredStyle: .alert)
             let onAction = UIAlertAction(title: "OK", style: .default, handler: { ACTION in
                 self.navigationController?.popViewController(animated: true)
             })
             resultAlert.addAction(onAction)
             present(resultAlert, animated: true, completion: nil)
             
         }else{
             let resultAlert = UIAlertController(title: "실패", message: "에러가 발생했습니다", preferredStyle: .alert)
             let onAction = UIAlertAction(title: "OK", style: .default, handler: { ACTION in
                 self.navigationController?.popViewController(animated: true)
             })
            
             resultAlert.addAction(onAction)
             present(resultAlert, animated: true, completion: nil)
             
         }
        
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
