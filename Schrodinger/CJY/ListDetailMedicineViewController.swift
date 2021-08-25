//
//  ListDetailMedicineViewController.swift
//  Schrodinger
//
//  Created by MacAir on 2021/08/02.
//

import UIKit

class ListDetailMedicineViewController: UIViewController {

    // 그림 연결
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var expClassify: UISegmentedControl!
    
    // 데이터 가져올 것 정의
    var feedMedicineItem: NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Cell의 크기 지정
        listTableView.rowHeight = 95

    }
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool){
        let medicineAllModel = MedicineAllModel()
        medicineAllModel.delegate = self
        medicineAllModel.downloadItems(check: "0")
        
        // MARK: - Table view data source
        listTableView.dataSource = self
        listTableView.delegate = self
    }
    
    // MARK: - func SegmentedControl
    @IBAction func expClassify(_ sender: UISegmentedControl) {
        
        let medicineAllModel = MedicineAllModel()
        medicineAllModel.delegate = self
        
        if sender.selectedSegmentIndex == 0{
            feedMedicineItem.removeAllObjects()
            listTableView.reloadData()
            medicineAllModel.downloadItems(check: "0")
        }else if sender.selectedSegmentIndex == 1{
            feedMedicineItem.removeAllObjects()
            listTableView.reloadData()
            medicineAllModel.downloadItems(check: "1")
        }else if sender.selectedSegmentIndex == 2{
            feedMedicineItem.removeAllObjects()
            listTableView.reloadData()
            medicineAllModel.downloadItems(check: "2")
        }
    }
    
} //------------ListDetailMedicineViewController-------------


// MARK: - extension : ListDetailMedicineViewController
// itemDownloaded라는 기능을 가지고 있는 extension
extension ListDetailMedicineViewController: MedicineAllModelProtocol{
    func itemDownloaded(items: NSMutableArray){

        // NSArray를 사용하면 []안에 String, Int 선언 안 해줘도 다 쓸 수 있음
        feedMedicineItem = items
        print("-----")
        let temp = feedMedicineItem[0] as! DBModel
        
        print(temp.name!)
        print("-----")
        self.listTableView.reloadData()
    
    }
}


// MARK: - extension : Table view data source
extension ListDetailMedicineViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "JpSong", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "DetailItemViewController") as! DetailItemViewController
        let id = self.feedMedicineItem[indexPath.row] as! DBModel
        receivepno = Int(id.pno!)
        let destinationNAC = UINavigationController(rootViewController: destinationVC)
        destinationNAC.modalPresentationStyle = .fullScreen
        present(destinationNAC, animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("==>", feedMedicineItem.count)
        return feedMedicineItem.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! TableViewCell

        // Configure the cell...
        let item: DBModel = feedMedicineItem[indexPath.row] as! DBModel

        // cell. 다음 tableViewCell 이름!
        // cell - 이미지
        let imgurl = share.imgUrl("\(item.image ?? "noImage.png")")
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: URL(string: imgurl)!) else { return }
            DispatchQueue.main.async {
                cell.imgMedicine.image = UIImage(data: data)
            }
        }
        // cell - 이름/유통기한
        cell.lblMedsName?.text = "\(item.name!)"
        cell.lblMedsExp?.text = "\(item.expirationDate!)"
        print("---", item.name!)

        return cell
    }
    
    
    // MARK: Table 셀 삭제(스와이프)

    // MARK: 1. DB 데이터 지우고(DeleteModel) 2. 화면 지우기(셀 수행)
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Delete")
            
        //    "\(item.name!)을 삭제하시겠습니까?"
            let temp = feedMedicineItem[indexPath.row] as! DBModel

            let cosmeticsDeleteAlert = UIAlertController(title: "삭제", message: "\(String(describing: temp.name!))을 삭제하시겠습니까?", preferredStyle: .alert)
            let onAction = UIAlertAction(title: "네", style: .destructive, handler: { [self]ACTION in

                let item = feedMedicineItem[indexPath.row] as! DBModel

                let deleteModel = ProductDeleteModel()
                _ = deleteModel.deleteItems(pno: item.pno!) // 사용하지 않지 않는 변수는 _(언더바)로 사용

                // *** 아래 2줄의 순서 중요함! ***
                feedMedicineItem.removeObject(at: indexPath.row) // 데이터 지우기
                tableView.deleteRows(at: [indexPath], with: .fade) // 테이블 지우기

            })
            
            let offAction = UIAlertAction(title: "아니오", style: .default, handler: nil)
            
            cosmeticsDeleteAlert.addAction(onAction)
            cosmeticsDeleteAlert.addAction(offAction)
            present(cosmeticsDeleteAlert, animated: true, completion: nil)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    // 삭제시 Delete를 삭제로 보이기
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "삭제"
    }
  
}
