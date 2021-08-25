//
//  DetailItemViewController.swift
//  Schrodinger
//
//  Created by ido on 2021/07/29.
//

import UIKit


// 지연님께 받아야하는 값
var receivepno = 1
var receiveuid = "" // 탭뷰에서 넘어올때 유저 아이디


var pname = "" // slq에서 상품의 이름 들어가는 곳


class DetailItemViewController: UIViewController {
    
    var receiveuno = Util.shared.id// 탭뷰에서 넘어올때 유저 no
    
    var MemoSend = ""
    var memo = ""
    var CurrenteDate = ""   // 현재날짜 넣기
    var editimagrFilepath = "" // 이미지 파이주소 넘기기
//    var Buttoncount = 0 // useall , Throw 버튼
    var QueryDetailcount = 0//QuertDetail에서 가져온 값들의 카운트
    var QueryTrowcount = 0//QuertThrow에서 가져온 값들의 카운트
    var QueryPurchasecount = 0//QuertThrow에서 가져온 값들의 카운트
    
    
    
    var QueryDetailItem: NSMutableArray = NSMutableArray()//  //QuertDetail에서 가져온 값들
    var QueryThrowItem: NSMutableArray = NSMutableArray()//  //QueryThrow에서 가져온 값들
    var DetailPurchaseItem: NSMutableArray = NSMutableArray()//  //QueryPurchase에서 가져온 값들
    
    var RegistrationItem: NSMutableArray = NSMutableArray()  // RegistrationdateModel에서 가져온 값들
    
    var throwlist: Array = Array<Any>() // DetailThrow 디비에서 불러오는 값들을 항목에 넣어준다
    var purchaselist: Array = Array<Any>() // DetailPurchase 디비에서 불러오는 값들을 항목에 넣어준다
    
    
    @IBOutlet weak var shadowView: UIView!
    //메모 업데이트 버튼
    @IBOutlet weak var D_lbl_registered: UILabel! // 이미지 하단에 등록일 띄우는 곳
    //@IBOutlet weak var D_lbl_image: UILabel!      // 이미지 중앙에 상품 이름 띄운다
    @IBOutlet weak var D_lbl_expirationDate: UILabel!  // 유통기한 날짜 편집에서 띄우는것
    @IBOutlet weak var D_imageview: UIImageView!     // 이미지뷰
    //@IBOutlet weak var D_lbl_item: UILabel!         // 현재 보유량
    @IBOutlet weak var D_lbl_throw: UILabel!          // 버린수 띄우기
    @IBOutlet weak var D_lbl_purchase: UILabel!       // 구매수
    @IBOutlet weak var D_tv_memo: UITextView!           // 메모
    @IBOutlet weak var D_btntf_commplete: UIButton!         // 사용완료 및 버리기 버튼
    
    let model = QueryDetail()
    let purchaseModel = QueryPurchase()
    let queryThrow = QueryThrow()
    
    //MARK: Navigation Bar Item
    func updateNavBar() {
        let backButton = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(backTo))
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(performEdit))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = editButton
        navigationItem.title = "Detail"
        navigationController?.navigationBar.tintColor = .systemGreen
    }
    
    @objc func performEdit() {
        performSegue(withIdentifier: "editSegue", sender: self)
    }
    @objc func backTo() {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        shadowView.layer.shadowOffset = .zero
        shadowView.layer.shadowRadius = 6
        shadowView.layer.shadowOpacity = 0.1
        shadowView.layer.masksToBounds = false
        
        updateNavBar()
        model.delegate = self
        purchaseModel.delegate = self
        queryThrow.delegate = self
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewMapTapped))
        D_tv_memo.addGestureRecognizer(tapGestureRecognizer)
        model.DetaildownItems(pno: receivepno)
    } //MARK: viewDidLoad
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(true)
       
    }//MARK: View Will Appear
    
    //MARK: 메모 클릭시 이벤트
    @objc func viewMapTapped(sender: UITapGestureRecognizer) {
        
        self.performSegue(withIdentifier: "sgMemo", sender: self)
        
    }
    // 네비게이션 정보 넘겨주기s
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "editSegue"{
            
            let editviewcontroller = segue.destination as! EdictViewController
            editviewcontroller.imageFilepath = editimagrFilepath
            editviewcontroller.receivepno = receivepno
            
        }else {
            
            //메모 텍스트 값 넘겨주기
            let Memoviewcontroller = segue.destination as! MemoViewController
            Memoviewcontroller.preparememo = "\(MemoSend)"
        }
    }
    
    //MARK: 완료 버튼
    @IBAction func D_btn_commplete(_ sender: UIButton) {
        let testAlert = UIAlertController(title: "please choose", message: "", preferredStyle: .actionSheet)
        // 현재 날짜 검색
        let formatter = DateFormatter(); formatter.dateFormat = "yyyy-MM-dd"
        CurrenteDate = "\(formatter.string(from: Date()))"
        
        let useAll = UIAlertAction(title: "Use all", style: .default) { _ in
            self.useallDate()
        }
        let throwAway = UIAlertAction(title: "Throw away", style: .destructive) { _ in
            self.throwDate()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        testAlert.addAction(useAll)
        testAlert.addAction(throwAway)
        testAlert.addAction(cancel)
        present(testAlert, animated: true, completion: nil)
        //Action
//        switch Buttoncount {
//        case 0 :
//
//            let actionDefault = UIAlertAction(title: "Use all", style: .default, handler:  { [self]ACTION in D_btntf_commplete.setTitle("Use all", for: .normal); Buttoncount = 1;})
//            let actionDestruction = UIAlertAction(title: "Throw away", style: .default, handler:  { [self]ACTION in D_btntf_commplete.setTitle("Throw away", for: .normal); Buttoncount = 2} )
//
//            let actionCancel = UIAlertAction(title: "Cancel", style: .destructive, handler:  { [self]ACTION in D_btntf_commplete.setTitle("Cancel", for: .normal); Buttoncount = 0} )
//
//            // Controller와 Action 걀합
//            testAlert.addAction(actionDefault)
//            testAlert.addAction(actionDestruction)
//            testAlert.addAction(actionCancel)
//
//            //화면 띄우기
//            present(testAlert, animated: true, completion: nil)
//
//        case  1 : useallDate()
//
//        case  2 : throwDate()
//
//        default: break
//
//        }
    }
    //MARK: 버린 날짜 입력 함수
    func useallDate()  {
        let useAllModel = UseAllModel()
        let result = useAllModel.UseAllItems(u_user_no: receiveuno, u_product_no: receivepno, useCompletionDate: CurrenteDate, pname: pname)
        resultAlert(result: result)
        //Buttoncount = 0 // 다시 초기화
        //self.dismiss(animated: true, completion: nil)
        //self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: 사용완료 날짜 입력 함수
    func throwDate() {
        let throwModel = ThrowModel()
        let result = throwModel.ThrowItems(u_user_no: receiveuno, u_product_no: receivepno, throwDate: CurrenteDate, pname: pname)
        resultAlert(result: result)
        //Buttoncount = 0 // 다시 초기화
        //self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: 버린날짜, 사용완료 Alert 중복
    func resultAlert(result: Bool) {
        if result {
            let resultAlert = UIAlertController(title: "완료", message: "처리하였습니다.", preferredStyle: .alert)
            let onAction = UIAlertAction(title: "OK", style: .default, handler: { ACTION in
                //self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
            })
            resultAlert.addAction(onAction)
            present(resultAlert, animated: true, completion: nil)
            
        }else{
            let resultAlert = UIAlertController(title: "실패", message: "에러가 발생했습니다", preferredStyle: .alert)
            let onAction = UIAlertAction(title: "OK", style: .default, handler: { ACTION in
                //self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
            })
            
            resultAlert.addAction(onAction)
            present(resultAlert, animated: true, completion: nil)
        }
    }
    
    //MARK: 홈뷰애서  지연님이 주실 pno 받아오는 과정
    func receiveid(item: Int){
        receivepno = item
    }
    
    //MARK: Load UI
    func loadDetailUI() {
        let item: DBDetailModel = QueryDetailItem[0] as! DBDetailModel //item값이 들어가있음
        //D_lbl_item.text = ("\(item.pname ?? "ss")")
        
        if MemoSend == "" {
            MemoSend = "\(item.memo ?? "실패")"
            D_tv_memo.text = MemoSend

        } else if MemoSend != ""{
            D_tv_memo.text = MemoSend
        }
        
        //MARK: 이미지 띄우는 코드
        
        let url = URL(string: "\(Share.imageurlIP)\(item.image ?? "싱패")")
        editimagrFilepath = "\(Share.imageurlIP)\(item.image ?? "싱패")"
        let data = try? Data(contentsOf: url!)
        D_imageview.image = UIImage(data: data!)
        D_lbl_expirationDate.text = "\(item.expirationDate ?? "실패")"
        pname = item.pname!
        //D_lbl_image.text = item.pname!
    }
    
    //MARK: 버린수 구한거 출력
    func Throw2 () {
        
        let item: DBDetailModel = QueryThrowItem[0] as! DBDetailModel //item값이 들어가있음
        
        D_lbl_throw.text = "\(item.throwDate ?? "싪")"
        throwlist.removeAll()
        
    }
    
    
    //MARK: 구매수 구하기
//    func Purchase () { //
//        purchaseModel.DetailPurchasedownloadItems(pname: pname, u_user_no: receiveuno)
//    }
    
    //MARK: 구매수 구한값 출력
    func Purchase2() {
        let item: DBDetailModel = DetailPurchaseItem[0] as! DBDetailModel //item값이 들어가있음
        D_lbl_purchase.text = "\(item.submitDate ?? "실패")"
        
    }
    
    
    //MARK: 등록 날짜 구하기
    func registration () { //
        let  registrationdateModel =  RegistrationdateModel()
        registrationdateModel.delegate = self
        registrationdateModel.RegistrationdatedownloadItems(s_product_no: receivepno, s_user_no: receiveuno)
        //print("여기는 viewcontrioller인데 registration로 들어가는 곳")
        
    }
    //MARK: 등록 날짜 구하기
    func registration2()  {
        let item: DBDetailModel = RegistrationItem[0] as! DBDetailModel //item값이 들어가있음
        D_lbl_registered.text = "\(item.submitDate ?? "실패")"
    }
    
    // 메모 업데이트 실행 버튼
//    @IBAction func D_btn_memoUpdate(_ sender: UIBarButtonItem) {
//        memoUpdate()
//    }
//    memoUpdate()
//    //메모 업데이트
//    func memoUpdate()  {
//        let memoUpdateModel = MemoUpdateModel()
//        let result = memoUpdateModel.MemoUpdateItems(pno: receivepno, memo: MemoSend)
//        resultAlert(result: result)
//        self.navigationController?.popViewController(animated: true)
//    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
}
//MARK: URL Delegate

extension DetailItemViewController : QueryDetailProtocol {
 
    func itemDownloaded(items: NSMutableArray, locationcont : Int) {
        QueryDetailItem = items
        self.QueryDetailcount = locationcont
        loadDetailUI()
        
        purchaseModel.DetailPurchasedownloadItems(pname: pname, u_user_no: receiveuno)
        queryThrow.DetailThrowdownloadItems(pname: pname, u_user_no: receiveuno)
    }
}


extension DetailItemViewController: QueryThrowProtocol{
    
    func DetailTrowitemDownloaded(items: NSMutableArray, locationcont : Int) {
        QueryThrowItem = items //가져온 data 가 들어올거임!

        self.QueryTrowcount = locationcont
        Throw2 () // 가져온 값들을 출력
    }
}

extension DetailItemViewController: QueryPurchaseProtocol{
    
    func DetailPurchaseitemDownloaded(items: NSMutableArray, locationcont : Int) {
        DetailPurchaseItem = items //가져온 data 가 들어올거임!

        self.QueryPurchasecount = locationcont
        Purchase2() // 가져온값들 출력
        registration ()
    }
}

extension DetailItemViewController: RegistrationdateProtocol{
    
    func RegistrationdateitemDownloaded(items: NSMutableArray, locationcont : Int) { //NSArray(배열 중 제일큰것) : 타입 꼭 지정안해도 ok..!?
        RegistrationItem = items //가져온 data 가 들어올거임!

        registration2()
    }
}

extension DetailItemViewController: MemoEdit{
    func didMessageEditDone(_ controller: MemoViewController, message: String) {
        MemoSend = message
    }
}
