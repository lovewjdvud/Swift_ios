//
//  SearchViewController.swift
//  Schrodinger
//
//  Created by ido on 2021/07/29.
//

import UIKit
import CoreFoundation

class SearchViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate, UISearchControllerDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("feedItem.count =" , feedItem.count)
        return feedItem.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! SearchTableViewCell
        let item:DBSearchModel = feedItem[indexPath.row] as! DBSearchModel
        DispatchQueue.global().async {
            guard let url = URL(string: "http://\(Util.shared.api):8080/schrodinger/images/\(item.image!)") else { return }
            guard let data = try? Data(contentsOf: url) else {
                return
            }
            DispatchQueue.main.async {
                cell.ImgView.image = UIImage(data: data)
            }
        }
      
       
        cell.NameTitle?.text = "물품명 : \(item.name!)"
        
        cell.Date?.text = "유통기간 : \(item.expirationDate!)"
        
        return cell
    }
    
    
    @IBOutlet weak var SearchBar: UISearchBar!
    @IBOutlet weak var SegmentControl: UISegmentedControl!
    @IBOutlet weak var listTableView: UITableView!
    
    var feedItem:NSArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.rowHeight = 60
        
        SearchBar.delegate = self
        searchWord(text: String.init())
      

        SearchBar.barStyle = .default
        SearchBar.placeholder = "물품 검색"

        SearchBar.translatesAutoresizingMaskIntoConstraints = true
        SearchBar.autoresizingMask = [.flexibleWidth]
        definesPresentationContext = true
        // Do any additional setup after loading the view.
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        let queryModel = SubmitQueryModel()
        queryModel.delegate = self
        queryModel.downloadItem(name: SearchBar.text!)
        }

        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            print("cancel")
            SearchBar.text = ""
        }
    
    func searchWord(text: String) {
           let searchedWordArray = feedItem.filter { word -> Bool in
               (word as AnyObject).name.compareWord(find: text)
           }
               feedItem = searchedWordArray as NSArray
               self.listTableView.reloadData()
       }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        let queryModel = SubmitQueryModel()
        queryModel.delegate = self
        queryModel.downloadItem(name: SearchBar.text!)
    }
    
    @IBAction func SegmentControl(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            let queryModel = SubmitQueryModel()
            queryModel.delegate = self
            queryModel.downloadItem(name: SearchBar.text!)
            
        }else if sender.selectedSegmentIndex == 1 {
            let queryModel = UseQueryModel()
            queryModel.delegate = self
            queryModel.downloadItemed(name: SearchBar.text!)
            
        }else if sender.selectedSegmentIndex == 2 {
            let queryModel = SearchQueryModel()
            queryModel.delegate = self
            queryModel.downloadItems(name: SearchBar.text!)
            
        }
    }
    
    /*
    // MARK: - Navigation
     //지금 합쳐지지 않아서 막아놓음 --> 테이블 셀 중 하나를 누르면 디테일 뷰로 해당 셀의 정보를 부르게 하기!!!!
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sgDetail"{
     let cell = sender as! UITableViewCell
     let indexPath = self.listTableView.indexPath(for: cell)
     let detailView = segue.destination as! DetailViewController
     
     let item:DBSearchModel = feedItem[indexPath!.row] as! DBSearchModel
     
     detailView.receivePno(pno: item.pno!)
     print(8)
     }
    }
    */
  
}
extension SearchViewController:UseQueryModelProtocol{
    func itemDownloaded(items: NSArray) {
        feedItem = items as! NSMutableArray
        self.listTableView.reloadData()
    }
}

extension SearchViewController:SearchQueryModelProtocol{
    func itemDownload(items: NSArray) {
        feedItem = items
        self.listTableView.reloadData()
    }
}

extension SearchViewController:SubmitQueryModelProtocol{
    func itemDownloads(items: NSArray) {
        feedItem = items as! NSMutableArray
        self.listTableView.reloadData()
    }
}

extension String {
    
    func compareWord(find: String) -> Bool {
        return self.range(of: find, options: [.caseInsensitive, .anchored]) != nil
    }
}


